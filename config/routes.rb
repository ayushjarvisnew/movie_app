Rails.application.routes.draw do

  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  get '/current_user', to: 'auth#current_user'

  get    'api/movies',     to: 'movies#index'
  get    'api/movies/:id', to: 'movies#show'
  post   'api/movies',     to: 'movies#create'
  patch    'api/movies/:id', to: 'movies#update'
  delete 'api/movies/:id', to: 'movies#destroy'

  resources :users, only: [:index, :show, :create, :update, :destroy] do
    member do
      patch :restore
    end
  end


  resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :theatres, only: [:index, :show, :create, :update, :destroy]

  resources :screens do
    resources :seats, only: [:index]
  end

  resources :seats, only: [:create]

  # resources :showtimes, only: [:index, :show, :create, :update, :destroy] do
  #   member do
  #     get 'available_seats'
  #     patch 'book_seats'
  #   end
  # end

  # Showtimes
  # resources :showtimes do
  #   member do
  #     get  :seats           # GET /api/showtimes/:id/seats → available seats
  #     post :book            # POST /api/showtimes/:id/book → book seats
  #   end
  # end
  resources :showtimes do
    # get :seats, on: :member         # GET /api/showtimes/:id/seats
    # post :book, on: :member  # POST /api/showtimes/:id/book
    member do
      get  :available_seats   # /showtimes/:id/available_seats
      post :book_seats        # /showtimes/:id/book_seats
    end
  end

  resources :reservations, only: [:index, :show, :create, :destroy] do
    collection do
      get 'my_reservations'
    end
    member do
      patch :restore
    end
  end

  root 'home#index'
  get '*path', to: 'home#index', constraints: ->(req) { !req.xhr? && req.format.html? }

  get '/api/info', to: 'home#api_status'

  # config/routes.rb
  post '/payments/initiate', to: 'payments#initiate'

  post '/payments/success', to: 'payments#success'
  get  '/payments/success', to: 'payments#success'

  post '/payments/failure', to: 'payments#failure'
  get  '/payments/failure', to: 'payments#failure'

end


# Rails.application.routes.draw do
#   # Auth
#   post   '/signup',       to: 'auth#signup'
#   post   '/login',        to: 'auth#login'
#   get    '/current_user', to: 'auth#current_user'
#
#   # Movies
#   get    '/api/movies',        to: 'movies#index'
#   get    '/api/movies/:id',    to: 'movies#show'
#   post   '/api/movies',        to: 'movies#create'
#   put    '/api/movies/:id',    to: 'movies#update'
#   delete '/api/movies/:id',    to: 'movies#destroy'
#   get    '/api/movies/:id/showtimes', to: 'movies#showtimes'
#
#   # Users
#   get    '/users',       to: 'users#index'
#   get    '/users/:id',   to: 'users#show'
#   post   '/users',       to: 'users#create'
#   put    '/users/:id',   to: 'users#update'
#   delete '/users/:id',   to: 'users#destroy'
#   patch  '/users/:id/restore', to: 'users#restore'
#
#   # Tags
#   get    '/tags',        to: 'tags#index'
#   get    '/tags/:id',    to: 'tags#show'
#   post   '/tags',        to: 'tags#create'
#   put    '/tags/:id',    to: 'tags#update'
#   delete '/tags/:id',    to: 'tags#destroy'
#
#   # Theatres
#   get    '/theatres',        to: 'theatres#index'
#   get    '/theatres/:id',    to: 'theatres#show'
#   post   '/theatres',        to: 'theatres#create'
#   put    '/theatres/:id',    to: 'theatres#update'
#   delete '/theatres/:id',    to: 'theatres#destroy'
#
#   # Screens & Seats
#   get    '/screens',            to: 'screens#index'
#   get    '/screens/:id',        to: 'screens#show'
#   post   '/screens',            to: 'screens#create'
#   put    '/screens/:id',        to: 'screens#update'
#   delete '/screens/:id',        to: 'screens#destroy'
#   get    '/screens/:screen_id/seats', to: 'seats#index'
#   post   '/seats',              to: 'seats#create'
#
#   # Showtimes
#   get    '/showtimes',          to: 'showtimes#index'
#   get    '/showtimes/:id',      to: 'showtimes#show'
#   post   '/showtimes',          to: 'showtimes#create'
#   put    '/showtimes/:id',      to: 'showtimes#update'
#   delete '/showtimes/:id',      to: 'showtimes#destroy'
#   get    '/showtimes/:id/available_seats', to: 'showtimes#available_seats'
#   patch  '/showtimes/:id/book_seats',      to: 'showtimes#book_seats'
#
#   # Reservations
#   get    '/reservations',       to: 'reservations#index'
#   get    '/reservations/my_reservations', to: 'reservations#my_reservations'
#   post   '/reservations',       to: 'reservations#create'
#   delete '/reservations/:id',   to: 'reservations#destroy'
#   patch  '/reservations/:id/restore', to: 'reservations#restore'
#
#   # Root & API info
#   root   'home#index'
#   get    '*path', to: 'home#index', constraints: ->(req) { !req.xhr? && req.format.html? }
#   get    '/api/info', to: 'home#api_status'
# end
