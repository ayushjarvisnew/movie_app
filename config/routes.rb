Rails.application.routes.draw do

  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  get '/current_user', to: 'auth#current_user'

  get    '/api/movies',          to: 'movies#index'
  get    '/api/movies/:id',      to: 'movies#show'
  post   '/api/movies',          to: 'movies#create'
  patch  '/api/movies/:id',      to: 'movies#update'
  delete '/api/movies/:id',      to: 'movies#destroy'
  get    '/api/movies/:id/showtimes', to: 'movies#showtimes'


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

  resources :showtimes, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'available_seats'
      patch 'book_seats'
    end
  end

  resources :reservations, only: [:index, :show, :create, :destroy] do
    collection do
      get 'my_reservations'
    end
  end

  root 'home#index'
  get '*path', to: 'home#index', constraints: ->(req) { !req.xhr? && req.format.html? }

  get '/api/info', to: 'home#api_status'
end
