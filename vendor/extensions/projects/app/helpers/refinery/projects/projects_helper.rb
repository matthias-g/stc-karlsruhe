module Refinery::Projects::ProjectsHelper

  def missing_volunteer_count
    @project.max_volunteer_count - @project.volunteers.count
  end
end