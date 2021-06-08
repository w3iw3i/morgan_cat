Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  post 'projection', to: 'pages#projection'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'assets', to: 'assets#index', as: :assets
  post 'assets', to: 'assets#create'
  patch 'assets', to: 'assets#update'

  # devise_scope :user do
  #   get 'sign_in', to: 'devise/sessions#new'


  # end

  resources :users do
    resources :expenses, only: [:index, :create, :destroy]
    resources :assets, only: [:index, :create, :update]
  end

end


