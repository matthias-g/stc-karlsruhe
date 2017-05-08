module ProjectUserRelationship extend ActiveSupport::Concern

included do

  def allow_add_volunteer_to_project?(volunteer, project)
    !project.has_volunteer?(volunteer) && project.has_free_places? && !project.closed? &&
        (user.eql?(volunteer) || (user && user.in_orga_team?))
  end

  def allow_remove_volunteer_from_project?(volunteer, project)
    project.has_volunteer?(volunteer) &&
        !project.closed? &&
        (user.eql?(volunteer) || (user && user.in_orga_team?))
  end

end #included

end