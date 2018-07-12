class Api::ApiController < ApplicationController
  abstract
  include JSONAPI::ActsAsResourceController

  respond_to :json
  acts_as_token_authentication_handler_for User, fallback: :none
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  skip_before_action :verify_authenticity_token # TODO: possibly CSRF danger, replace session by auth tokens

  def user_not_authorized(exception)
    if user_signed_in?
      head :forbidden
    else
      head :unauthorized
    end
  end

  protected

  def context
     { user: current_user }
  end
end