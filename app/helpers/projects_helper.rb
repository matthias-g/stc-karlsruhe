module ProjectsHelper

  def list_users(users)
    existing_users = users.where(cleared: false)
    deleted_users_count = users.where(cleared: true).count
    output = existing_users.map { |v| link_to(v.first_name, user_path(v)) }.join(', ')
    if deleted_users_count > 0
      output += ' + ' if existing_users.count > 0
      output += deleted_users_count.to_s + ' ' + User.model_name.human(count: deleted_users_count)
    end
    output.html_safe
  end

  def show_gallery?(project)
    project.gallery.gallery_pictures.visible_for_user(current_user).any? && !project.hidden?
  end

  def show_contains_invisible_pictures_notification?(project)
    hidden_pics = project.gallery.gallery_pictures.where(visible: false)
    current_user && (hidden_pics.where(uploader_id: current_user.id).any? || (current_user.admin? && hidden_pics.any?))
  end

  def options_for_user_select
    options = User.all.where(cleared: false).order(:first_name, :last_name).map do |user|
      [user.full_name, user.id, {data: { tokens: user.username }}]
    end
    options_for_select(options)
  end

end
