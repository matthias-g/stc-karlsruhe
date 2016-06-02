class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by ignoring session
  protect_from_forgery

  before_filter :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


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

  def not_authorized
    raise ActionController::RoutingError.new('Not Authorized')
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      redirect_to '/'
    end
  end

  def after_sign_in_path_for(resource)
    template = Surveys::Template.joins('LEFT JOIN surveys_submissions ON surveys_submissions.template_id = surveys_templates.id')
                   .where(show_in_user_profile: true)
                   .where('surveys_submissions.user_id != ? or surveys_submissions.user_id is null', current_user.id)
                   .order('RANDOM()').first
    sign_in_url = new_user_session_url
    if template
      signed_in_root_path(resource)
    elsif request.referer == sign_in_url || request.referer == login_or_register_url || request.referer =~ /.*\/password\/.*/
      super
    else
      stored_location_for(resource) || request.referer || signed_in_root_path(resource)
    end
  end

  def signed_in_root_path(resource_or_scope)
    user_path(current_user)
  end

  def user_not_authorized(exception)
    if user_signed_in?
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
      redirect_to(request.referrer || root_path)
    else
      redirect_to login_or_register_url
    end
  end

end
