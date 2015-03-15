class Devise::CustomFailure < Devise::FailureApp

  def redirect_url
    login_or_register_url
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