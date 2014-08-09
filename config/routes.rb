Rails.application.routes.draw do
  resources :guests

  root to: 'users#index'
  post 'twilio/messaging' => 'twilio#messaging'

  resources :users
end
