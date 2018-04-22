class EventPolicy < ApplicationPolicy

  include EventUserRelationship

  class Scope < Scope
    def resolve
      if user && (user.admin? || user.coordinator?)
        scope.all
      elsif user
        scope.joins('JOIN actions ON events.initiative_id = actions.id')
            .joins('LEFT JOIN leaderships policyLeaderships on actions.id = policyLeaderships.action_id')
            .where('policyLeaderships.user_id = ? OR visible', user.id).distinct
      else
        scope.joins('JOIN actions ON events.initiative_id = actions.id').where('actions.visible': true).distinct
      end
    end
  end

  def enter?
    add_to_volunteers? [user]
  end

  def leave?
    remove_from_volunteers? user
  end

  def manage_team?
    (is_admin? || is_coordinator? || is_leader?) && !record.finished?
  end

  def add_to_volunteers?(users)
    users.all? { |user| allow_add_volunteer_to_event?(user, record) }
  end

  def remove_from_volunteers?(user)
    allow_remove_volunteer_from_event?(user, record)
  end

  def replace_volunteers?(users)
    allowed = true
    record.volunteers.each do |volunteer|
      allowed &= users.include?(volunteer) || remove_from_volunteers?(volunteer)
    end
    users.each do |user|
      allowed &= is_volunteer?(user) || add_to_volunteers?([user])
    end
    allowed
  end

  def updatable_fields
    [:desired_team_size, :team, :date, :initiative, :volunteers]
  end

  alias_method :delete_volunteer?, :manage_team?

  private

  def is_volunteer?(user)
    record.volunteer?(user)
  end

  def is_leader?
    record.initiative.leader?(user)
  end

end
