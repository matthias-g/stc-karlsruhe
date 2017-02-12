module ProjectUserRelationship extend ActiveSupport::Concern

included do

  def allow_add_volunteer_to_project?(volunteer, project)
    !project.has_volunteer?(volunteer) && project.has_free_places? && !project.closed? &&
        (user == volunteer || (user && user.admin?))
  end

  def allow_remove_volunteer_from_project?(volunteer, project)
    project.has_volunteer?(volunteer) &&
        !project.closed? &&
        (user == volunteer || (user && user.admin?))
  end

end

end