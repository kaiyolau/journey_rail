Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'journeys#index', as: :root

  resources :journeys do
    resources :comments, only: [:create, :destroy]
    resources :likes, shallow: true, only: [:create, :destroy]

    get :liked, on: :collection
    get :timeNow, on: :collection
    resources :likers, only: [:index, :show]
  end

  resources :users, only:[:new, :create, :show]

  resource :session, only:[:new, :create, :destroy]

  namespace :api, defaults:{format: :json} do
    namespace :v1 do
      resources :journeys, only: [:index, :show, :create, :update, :destroy]
      resource :session, only: [:create, :destroy]
      resources :users, only: [:create] do
        #get('users/current', {to: 'users#current'})
        #default api/v1/users/:id/current
        get :current, on: :collection #api/v1/users/current because <current> action is custom path so we need to use this
      end
    end
    resources :gifts, only: [:create]
  end


  #OmniAuth Routes
  get "/auth/github", as: :sign_in_with_github
  get "/auth/google", as: :sign_in_with_google
  get "/auth/:provider/callback", to: "callbacks#index"
  #:provider will aloow us to use the same controller and action for different authentication systems
  #such as github, twittter, facebook, etc.



end
