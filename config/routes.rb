Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  root to: 'pages#home'

  get 'projection', to: 'pages#projection'
  get 'scenario_planning', to: 'pages#scenario_planning'
  get 'property', to: 'pages#property'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :assets, only: [:index]
  post '/create-assets', to: 'assets#create'
  patch '/update-assets/:id', to: 'assets#update'

  resources :properties, only: [:index, :create, :edit, :update, :destroy]
  # post '/create-properties', to: 'properties#create'
  # get '/update-properties/:id', to: 'properties#edit'
  # patch '/update-properties/:id', to: 'properties#update'
  # delete '/delete-properties/:id', to: 'properties#destroy'

  resources :users do
    resources :expenses, only: [:index, :create, :destroy]
  end

end


