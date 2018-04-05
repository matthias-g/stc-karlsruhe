module ActionUserRelationship
  extend ActiveSupport::Concern

  included do

    def allow_add_volunteer_to_action?(volunteer, action)
      allow_edit_volunteer?(volunteer, action) && !action.volunteer?(volunteer) && action.available_places.positive?
    end

    def allow_remove_volunteer_from_action?(volunteer, action)
      allow_edit_volunteer?(volunteer, action) && action.volunteer?(volunteer)
    end

    def allow_edit_volunteer?(volunteer, action)
      user && (user.eql?(volunteer) || user.in_orga_team?) && !action.finished?
    end

  # When changing this line keep bin/travis-mutant in mind
  end #included

end