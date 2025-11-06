# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'http://localhost:3000', 'http://0.0.0.0:3000'
#
#     resource '*',
#              headers: :any,
#              methods: [:get, :post, :put, :patch, :delete, :options, :head],
#              credentials: true
#   end
# end
#
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000','http://127.0.0.0:3000', 'https://movie-app-3cv5.onrender.com'
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             credentials: true
  end
end