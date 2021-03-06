class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :json

  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:error] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      render :new
    end
  end
end