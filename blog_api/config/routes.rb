Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          put :update_role
          put :update_ban_status
          put :update_password
        end
      end
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'refresh', to: 'sessions#refresh'
      resources :roles, only: [:index, :show]
      resources :blogs do
        resources :comments
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
