Refinery::AdminController.class_eval do

  before_filter :redirect_non_refinery_users

  def redirect_non_refinery_users
    unless current_refinery_user.has_role?(:refinery)
      redirect_to '/profile'
    end
  end

end
