Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'
  post 'twilio/messaging' => 'twilio#messaging'

  resources :users do
    get :dashboard, on: :member
  end
  resources :guests
end
