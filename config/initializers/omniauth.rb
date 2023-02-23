# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], scope: "read:user, read:email"
# end


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], scope: "read:user, read:email"
  provider :GoogleOauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], scope: "read:user, read:email"
end



# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider OmniAuth::Strategies::GoogleOauth2, ENV["KEY"], ENV["SECRET"]
# end
