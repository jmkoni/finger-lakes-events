Rails.application.routes.draw do
  passwordless_for :users
  resources :events do
    collection do
      get :list
    end
    member do
      post :approve
      post :reject
    end
  end
  resources :users
  # Defines the root path route ("/")
  root to: "events#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
