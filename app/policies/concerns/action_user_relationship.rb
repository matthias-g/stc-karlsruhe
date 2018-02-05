module ActionUserRelationship
  extend ActiveSupport::Concern

  included do

    def allow_add_volunteer_to_action?(volunteer, action)
      !action.volunteer?(volunteer) && action.free_places.nonzero? && !action.finished? && (user.eql?(volunteer) || (user && user.in_orga_team?))
    end

    def allow_remove_volunteer_from_action?(volunteer, action)
      action.volunteer?(volunteer) && !action.finished? && (user.eql?(volunteer) || (user && user.in_orga_team?))
    end

  end

end