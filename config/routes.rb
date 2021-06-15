Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  root to: 'pages#home'

  get 'projection', to: 'pages#projection'
  get 'scenario_planning', to: 'pages#scenario_planning'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :assets, only: [:index]


  post '/create-assets', to: 'assets#create'
  patch '/update-assets/:id', to: 'assets#update'

  # devise_scope :user do
  #   get 'sign_in', to: 'devise/sessions#new'


  # end


  resources :users do
    resources :expenses, only: [:index, :create, :destroy]
  end

end


