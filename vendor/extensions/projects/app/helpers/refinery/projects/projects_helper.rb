module Refinery::Projects::ProjectsHelper

  def missing_volunteer_count
    @project.max_volunteer_count - @project.volunteers.count
  end

  def linkname(user)
    if user.username.match(/\s/)
      user.id
    else
      user.username
    end
  end
end