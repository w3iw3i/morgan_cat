Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  root to: 'pages#home'

  get 'projection', to: 'pages#projection'
  get 'scenario_planning', to: 'pages#scenario_planning'
  get 'property', to: 'pages#property'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :assets, only: [:index]
  post '/create-assets', to: 'assets#create'
  get '/update-assets/:id', to: 'assets#edit'
  patch '/update-assets/:id', to: 'assets#update'
  delete 'delete-assets/:id', to: 'assets#destroy'

  resources :properties, only: [:index]
  post '/create-properties', to: 'properties#create'

  resources :users do
    resources :expenses, only: [:index, :create, :destroy]
  end

end


