Rails.application.routes.draw do
  resources :guests

  root to: 'users#index'

  resources :users
end
