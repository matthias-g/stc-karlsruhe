Refinery::SessionsController.class_eval do

  def signed_in_root_path(resource_or_scope)
    '/profile'
  end

end
