module EventUserRelationship
  extend ActiveSupport::Concern

  included do

    def allow_add_volunteer_to_event?(volunteer, event)
      allow_edit_volunteer?(volunteer, event) && !event.volunteer?(volunteer) && (event.team_size < event.desired_team_size)
    end

    def allow_remove_volunteer_from_event?(volunteer, event)
      allow_edit_volunteer?(volunteer, event) && event.volunteer?(volunteer)
    end

    def allow_edit_volunteer?(volunteer, event)
      return nil unless user
      user.in_orga_team? || ((user.eql?(volunteer) || event.initiative.leader?(user)) && !event.finished?)
    end

  # When changing this line keep bin/travis-mutant in mind
  end #included

end
