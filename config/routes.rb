Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'assets', to: 'assets#index'
  post 'assets', to: 'assets#create'
  patch 'assets', to: 'assets#update'

end
