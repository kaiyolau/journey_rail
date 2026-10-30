# Idempotent sample data for demos. Safe to run more than once.
#   bundle exec rails runner db/sample_data.rb
# Stubs the geocoder so no external lookup is made and coordinates stay as given.
Geocoder.configure(lookup: :test)

PASSWORD = "Demo1234!"

users = [
  ["Admin", "User", "admin.demo@example.com", true],
  ["Alice", "Chen", "alice.demo@example.com", false],
  ["Brian", "Singh", "brian.demo@example.com", false],
  ["Carla", "Gomez", "carla.demo@example.com", false],
].map do |first, last, email, admin|
  User.find_or_create_by!(email: email) do |u|
    u.first_name = first
    u.last_name = last
    u.password = PASSWORD
    u.is_admin = admin
  end
end
alice, brian, carla = users[1], users[2], users[3]

journeys = [
  [alice, "Sunrise hike at Lion's Head", "Started at 5am to catch the sunrise over Cape Town. The last stretch has chains and ladders, but the view of the city and the ocean is unforgettable.", "Sunny", "Lion's Head, Cape Town, South Africa", -33.9358, 18.3879, "hiking, nature, sunrise"],
  [alice, "Cherry blossoms in Kyoto", "Walked the Philosopher's Path in full bloom. Go early in the morning to avoid crowds and stop for matcha at one of the small tea houses along the canal.", "Cloudy", "Philosopher's Path, Kyoto, Japan", 35.0270, 135.7948, "japan, spring, photography"],
  [brian, "Road trip along the Pacific Coast", "Five days from Vancouver to San Francisco. Best stops: Cannon Beach, the Redwoods, and a very windy night in Big Sur.", "Rainy", "Cannon Beach, Oregon, USA", 45.8918, -123.9615, "roadtrip, usa, coast"],
  [brian, "Street food tour in Bangkok", "Ate my way through Yaowarat at night. Pad thai, mango sticky rice, and grilled river prawns. Bring cash and an empty stomach.", "Thunderstorms", "Yaowarat Road, Bangkok, Thailand", 13.7396, 100.5100, "food, thailand, night"],
  [carla, "First snow in Banff", "Lake Louise was frozen and quiet. We rented skates and spent the whole afternoon on the ice before warming up with hot chocolate.", "Snowy", "Lake Louise, Banff, Canada", 51.4254, -116.1773, "canada, winter, mountains"],
  [carla, "Museum day in Paris", "The Louvre in the morning and Musee d'Orsay in the afternoon. Buy tickets online ahead of time and start with the Impressionist floor.", "Cloudy", "Musee d'Orsay, Paris, France", 48.8600, 2.3266, "art, paris, museums"],
  [alice, "Surf lesson in Tofino", "Cold water but friendly waves. Our instructor had us standing on the board within an hour. The wetsuit is not optional.", "Sunny", "Cox Bay, Tofino, Canada", 49.1010, -125.8830, "surfing, canada, beach"],
  [brian, "Hot air balloons in Cappadocia", "Up at 4am, floating over fairy chimneys at sunrise with hundreds of other balloons. Worth every minute of lost sleep.", "Sunny", "Goreme, Cappadocia, Turkey", 38.6431, 34.8289, "turkey, sunrise, adventure"],
]

tag_cache = {}
created = journeys.map do |user, title, body, weather, address, lat, lng, tags|
  Geocoder::Lookup::Test.add_stub(address, [{ "coordinates" => [lat, lng] }])
  j = Journey.find_by(user: user, title: title.capitalize) ||
      Journey.create!(user: user, title: title, body: body, weather: weather,
                      address: address, latitude: lat, longitude: lng,
                      timing: Time.current - rand(1..300).days)
  tags.split(", ").each do |name|
    tag = (tag_cache[name] ||= Tag.find_or_create_by!(name: name))
    Tagging.find_or_create_by!(journey: j, tag: tag)
  end
  j
end

comments = [
  "This looks amazing, adding it to my list!",
  "Great tips, thanks for sharing.",
  "I went last year and loved it too.",
  "Any advice on the best time of year to go?",
]
created.each_with_index do |j, i|
  next if j.comments.exists?
  2.times do |k|
    Comment.create!(journey: j, user: (users - [j.user])[(i + k) % 3], body: comments[(i + k) % comments.size])
  end
end

users.each do |u|
  created.each_with_index do |j, i|
    next if j.user == u || (i + u.id) % 2 == 1
    Like.find_or_create_by!(user: u, journey: j)
  end
end

if Gift.count.zero?
  Gift.create!(sender: brian, receiver: alice, journey: created[0], amount: 500, status: "paid", payment_id: "demo_001")
  Gift.create!(sender: carla, receiver: brian, journey: created[3], amount: 1000, status: "paid", payment_id: "demo_002")
end

puts "Users=#{User.count} Journeys=#{Journey.count} Tags=#{Tag.count} Comments=#{Comment.count} Likes=#{Like.count} Gifts=#{Gift.count}"
