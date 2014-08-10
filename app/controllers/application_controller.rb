class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_logged_in

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :address, :phone, :email, :password, :password_confirmation, :size) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :address, :phone, :email, :password, :password_confirmation, :size) }
  end

  def redirect_if_logged_in
    if current_user && !devise_controller?
      redirect_to polymorphic_path([:dashboard, current_user])
    end
  end
end
