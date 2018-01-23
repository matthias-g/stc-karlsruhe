module ActionUserRelationship
  extend ActiveSupport::Concern

included do

  def allow_add_volunteer_to_action?(volunteer, action)
    !action.has_volunteer?(volunteer) && action.has_free_places? && !action.closed? &&
        (user.eql?(volunteer) || (user && user.in_orga_team?))
  end

  def allow_remove_volunteer_from_action?(volunteer, action)
    action.has_volunteer?(volunteer) &&
        !action.closed? &&
        (user.eql?(volunteer) || (user && user.in_orga_team?))
  end

end #includedf

end