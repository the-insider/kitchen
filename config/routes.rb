Rails.application.routes.draw do
  namespace :api do
    resources :restaurants do
      resources :menus
    end
  end

  # Prometheus metrics endpoint
  get '/metrics', to: 'metrics#index'

  # Version endpoint
  get '/version', to: 'version#index'
end
