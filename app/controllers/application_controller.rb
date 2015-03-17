class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(
        :username, :email, :first_name, :last_name,:password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(
        :login, :username, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(
        :username, :email, :first_name, :last_name, :phone,
        :password, :password_confirmation, :current_password) }
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.is_admin?
      redirect_to '/'
    end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

end
