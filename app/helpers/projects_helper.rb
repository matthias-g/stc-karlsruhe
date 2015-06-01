module ProjectsHelper

  def list_users(users)
    existing_users = users.where(cleared: false)
    deleted_users_count = users.where(cleared: true).count
    output = existing_users.map { |v| link_to(v.first_name , user_path(v)) }.join(', ')
    if deleted_users_count > 0
      output += ' + ' if existing_users.count > 0
      output += deleted_users_count.to_s + ' ' + User.model_name.human(count: deleted_users_count)
    end
    output.html_safe
  end

  def show_gallery?(project)
    project.gallery.gallery_pictures.visible_for_user(current_user).count > 0
  end

  def show_upload?(project)
    project.has_volunteer?(current_user) || project.has_leader?(current_user) || (current_user && current_user.is_admin?)
  end

end
