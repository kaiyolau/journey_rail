Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
      origins 'http://127.0.0.1:5500', 'localhost:5500', 'localhost:9999', 'localhost:3434', 'localhost:3002' #whitelisted domains or "vip" domains
      #these are the domains that you are allowing to send requests to your api server

      resource(
          '/api/*', #we want them only to have the access to localhost:3000/api/something/etc
          headers: :any, #all the requests can contain any headers
          credentials: true, #because we are sending cookies with the requests
          methods: [:get, :post, :patch, :put, :delete, :options] #allow for all of there http verbs
          #for these types of request to be sent to your api
          #options verb is being usefd under the hood for CORS to work, and must be present
      )
  end
end
