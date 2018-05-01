class EventPolicy < ApplicationPolicy

  include EventUserRelationship

  class Scope < Scope
    def resolve
      if user&.in_orga_team?
        scope.all
      elsif user
        scope.left_outer_joins(initiative: :leaderships).where('actions.visible OR leaderships.user_id = ?', user.id).distinct
      else
        scope.joins(:initiative).where(actions: {visible: true}).distinct
      end
    end
  end


  def enter?
    allow_add_volunteer_to_event?(user, record)
  end

  def leave?
    allow_remove_volunteer_from_event?(user, record)
  end

  def manage_team?
    return false unless user
    user.in_orga_team? || (record.initiative.leader?(user) && !record.finished?)
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
      allowed &= record.volunteer?(user) || add_to_volunteers?([user])
    end
    allowed
  end


  alias_method :delete_volunteer?, :manage_team?


  def updatable_fields
    [:desired_team_size, :team, :date, :initiative, :volunteers]
  end

end
