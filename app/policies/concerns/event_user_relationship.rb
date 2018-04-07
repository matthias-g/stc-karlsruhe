module EventUserRelationship
  extend ActiveSupport::Concern

  included do

    def allow_add_volunteer_to_event?(volunteer, event)
      allow_edit_volunteer?(volunteer, event) && !event.volunteer?(volunteer) && event.available_places.positive?
    end

    def allow_remove_volunteer_from_event?(volunteer, event)
      allow_edit_volunteer?(volunteer, event) && event.volunteer?(volunteer)
    end

    def allow_edit_volunteer?(volunteer, event)
      user && (user.eql?(volunteer) || user.in_orga_team?) && !event.finished?
    end

  # When changing this line keep bin/travis-mutant in mind
  end #included

end