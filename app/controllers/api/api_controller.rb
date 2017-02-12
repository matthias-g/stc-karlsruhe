module Api
  class ApiController < ApplicationController

    respond_to :json
    acts_as_token_authentication_handler_for User, fallback: :none
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def user_not_authorized(exception)
      if user_signed_in?
        head :forbidden
      else
        head :unauthorized
      end
    end
  end
end