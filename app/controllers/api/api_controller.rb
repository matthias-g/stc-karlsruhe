module Api
  class ApiController < ApplicationController

    respond_to :json

    def user_not_authorized(exception)
      if user_signed_in?
        head :forbidden
      else
        head :unauthorized
      end
    end
  end
end