Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'
  post 'twilio/messaging' => 'twilio#messaging'

  resources :users
  resources :guests
end
