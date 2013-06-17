Refinery::Admin::ImagesController.class_eval do
  skip_before_filter :redirect_non_refinery_users, :only => :insert

  def insert
    self.new if @image.nil?

    @url_override = refinery.admin_images_path(request.query_parameters.merge(:insert => true))

    if params[:conditions].present?
      extra_condition = params[:conditions].split(',')

      extra_condition[1] = true if extra_condition[1] == "true"
      extra_condition[1] = false if extra_condition[1] == "false"
      extra_condition[1] = nil if extra_condition[1] == "nil"
    end

    conditions = {}
    conditions.merge! ({extra_condition[0].to_sym => extra_condition[1]}) if extra_condition.present?
    conditions.merge! ({:user_id => current_refinery_user.id}) unless current_refinery_user.is_admin?
    find_all_images(conditions)
    search_all_images if searching?

    paginate_images

    render :action => "insert"
  end


end