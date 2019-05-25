class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by ignoring session
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email, :first_name, :last_name,
                                                        :phone, :password, :password_confirmation, :privacy_consent])
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login, :username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :email, :first_name, :last_name, :phone,
                                                               :password, :password_confirmation, :current_password])
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def not_authorized
    raise ActionController::RoutingError.new('Not Authorized')
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      redirect_to '/'
    end
  end

  def authenticate_admin_or_coordinator!
    authenticate_user!
    unless current_user.admin? || current_user.coordinator?
      redirect_to '/'
    end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    template = Surveys::Template.where(show_in_user_profile: true).order(Arel.sql('RANDOM()')).first
    if template && !template.submissions.where(user_id: current_user.id).exists?
      stored_location_for(resource) || signed_in_root_path(resource)
    elsif request.referer == sign_in_url || request.referer == new_user_session_url || request.referer =~ /.*\/password\/.*/
      super
    else
      stored_location_for(resource) || request.referer || signed_in_root_path(resource)
    end
  end

  def signed_in_root_path(_resource_or_scope)
    user_path(current_user)
  end

  def user_not_authorized(exception)
    if user_signed_in?
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
      redirect_to(request.referrer || root_path)
    else
      redirect_to new_user_session_path
    end
  end

  #def current_user
  #  @current_user ||= super && User.order(id: :asc).includes(:roles).find(@current_user.id)
  #end

  # Makes the output of the given controller action available in the view
  def include_request(url_helper, controller_class, action, params)
    controller = controller_class.new
    controller.request = request
    controller.response = controller_class.make_response!(request)
    controller.params = ActionController::Parameters.new(params.merge(controller: controller_class.controller_path, action: action))
    request_url = Rails.application.routes.url_helpers.public_send(url_helper, params)
    @included_requests ||= {}
    @included_requests[request_url] = controller.send(action)
  end

end
