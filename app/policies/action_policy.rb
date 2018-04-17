class ActionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && (user.admin? || user.coordinator?)
        scope.all
      elsif user
        scope.joins('LEFT JOIN leaderships policyLeaderships on actions.id = policyLeaderships.action_id')
            .where('policyLeaderships.user_id = ? OR visible', user.id).distinct
      else
        scope.where(visible: true).distinct
      end
    end
  end

  def index?
    is_admin? || is_coordinator?
  end

  def create?
    is_admin? || is_coordinator?
  end

  def show?
    record.visible? || edit?
  end

  def edit?
    is_admin? || is_coordinator? || is_leader?
  end

  def manage_team?
    edit? && !record.finished?
  end

  def change_visibility?
    is_admin? || is_coordinator?
  end

  def updatable_fields
    all_fields = [:title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements,
                  :visible, :short_description, :map_latitude, :map_longitude, :map_zoom,
                  :picture, :picture_source, :events, :action_group, :parent_action, :leaders, :volunteers]
    return all_fields - [:visible] unless is_admin? || is_coordinator?
    all_fields
  end

  def contact_volunteers?
    record.visible? && edit?
  end

  def contact_leaders?
    record.visible? && is_volunteer?(user) && !record.finished?
  end

  def enter_subaction?
    (record.total_available_places > record.available_places) && !record.volunteers_in_subactions.include?(user)
  end

  def upload_pictures?
    is_today_or_past? && (is_volunteer?(user) || is_leader? || is_coordinator? || is_admin? || user&.photographer?)
  end

  alias_method :clone?, :edit?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  alias_method :make_visible?, :change_visibility?
  alias_method :make_invisible?, :change_visibility?

  alias_method :crop_picture?, :edit?
  alias_method :edit_leaders?, :edit?
  alias_method :add_leader?, :edit_leaders?
  alias_method :delete_leader?, :edit_leaders?
  alias_method :remove_from_volunteers?, :is_admin?


  def is_leader?
    record.leader?(user)
  end

  def is_volunteer?(user)
    record.volunteer?(user)
  end

  private

  def is_today_or_past?
    today_or_future = nil
    record.dates.each do |date|
      today_or_future ||= date.today? || date.past?
    end
    today_or_future
  end

end
