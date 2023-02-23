# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Destroy all records in the database before creating new data:
Tagging.destroy_all
Tag.destroy_all
Journey.destroy_all
Comment.destroy_all
User.destroy_all

# To access Faker, remember to add the faker gem to Gemfile and run: bundle

PASSWORD = "123"
super_user = User.create(
  first_name: "Admin",
  last_name: "User",
  email: "admin@user.com",
  password: PASSWORD,
  is_admin: true
)

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name}@#{last_name}.com",
    password: PASSWORD
  )
end

users = User.all

NUM_TAGS = 20
NUM_TAGS.times do
  Tag.create(
    name: Faker::ProgrammingLanguage.name
  )
end

tags = Tag.all
weatherList = ['Sunny', 'Cloudy', 'Rainy', 'Snowy', 'Tornadoes', 'Thunderstorms', 'typhoons', 'Blizzards', 'Droughts']

50.times do
  created_at = Faker::Date.backward(days:365 * 5)

  j = Journey.create(
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    # address: "628 6th Avenue, New Westminster, BC,Canada", #CodeCore's address
    # latitude: 49.3043,
    # longitude: -123.1443, #negative is West coordinate
    address: Faker::Address.full_address,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    created_at: created_at,
    updated_at: created_at,
    user: users.sample
  )
  if j.valid?
    rand(0..2).times do
      Comment.create(body: Faker::Hacker.say_something_smart, journey:j, user: users.sample)
    end
    j.tags = tags.shuffle.slice(0, rand(tags.count))
  end
end

journeys = Journey.all
comments = Comment.all

puts Cowsay.say("Generated #{journeys.count} journeys", :frogs)
puts Cowsay.say("Generated #{comments.count} comments", :dragon)
puts Cowsay.say("Generated #{users.count} users", :koala)
puts Cowsay.say("Generated #{Tag.count} tags", :bunny)

# To run this file use command: rails db:seed
