Refinery::Admin::ImagesController.class_eval do
  skip_before_filter :redirect_non_refinery_users, :only => :insert
end