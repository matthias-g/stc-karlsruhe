class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash[:error] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      redirect_to request.referer
    end
  end
end