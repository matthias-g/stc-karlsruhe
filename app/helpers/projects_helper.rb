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

  # for projects and news_entries
  def show_gallery?(item)
    (item.gallery && policy_scope(item.gallery.gallery_pictures).any?) && item.visible?
  end

  def show_contains_invisible_pictures_notification?(project)
    current_user && (project.gallery.gallery_pictures.invisible.where(uploader_id: current_user.id).count > 0 ||
        ((current_user.admin? || current_user.coordinator?) && project.gallery.gallery_pictures.invisible.any?))
  end

  def available_projects(project)
    if project.project_week
      project.project_week.projects
    else
      Project.where(project_week: nil)
    end
  end

end
