Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'
  post 'twilio/messaging' => 'twilio#messaging'

  resources :users do
    get :dashboard, on: :member
    get :printout, on: :member
  end

  # match '/donate_success', to: 'users#donate_success'
  resources :guests
end
