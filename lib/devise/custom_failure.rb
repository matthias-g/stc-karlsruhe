class Devise::CustomFailure < Devise::FailureApp

  def route(scope)
    login_or_register_user_url()
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

end