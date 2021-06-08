Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  post 'projection', to: 'pages#projection'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :assets, only: [:index]

  post '/create-assets', to: 'assets#create'
  patch '/update-assets/:id', to: 'assets#update'

  resources :users do
    resources :expenses, only: [:index, :create, :destroy]
  end

end
