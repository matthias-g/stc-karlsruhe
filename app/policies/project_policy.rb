class ProjectPolicy < ApplicationPolicy

  include ProjectUserRelationship

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      elsif user
        scope.joins('LEFT JOIN leaderships on projects.id = leaderships.project_id')
            .where(leaderships: {user_id: user.id})
            .or(
                scope.joins('LEFT JOIN leaderships on projects.id = leaderships.project_id')
                    .where(visible: true).references(:leaderships)
            ).distinct
      else
        scope.joins('LEFT JOIN leaderships on projects.id = leaderships.project_id').where(visible: true).distinct
      end
    end
  end

  def index?
    is_admin?
  end

  def create?
    is_admin?
  end

  def show?
    record.visible? || edit?
  end

  def edit?
    is_admin? || is_leader?
  end

  def contact_volunteers?
    record.visible? && edit?
  end

  def enter?
    add_to_volunteers? [user]
  end

  def leave?
    remove_from_volunteers? user
  end

  def upload_pictures?
    record.visible? && is_today_or_past? && (is_volunteer?(user) || is_leader? || is_admin? || (user && user.photographer?))
  end

  def add_to_volunteers?(users)
    users.all? { |user| allow_add_volunteer_to_project?(user, record) }
  end

  def remove_from_volunteers?(user)
    allow_remove_volunteer_from_project?(user, record)
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

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  alias_method :open?, :edit?
  alias_method :close?, :edit?
  alias_method :change_visibility?, :is_admin?
  alias_method :make_visible?, :change_visibility?
  alias_method :make_invisible?, :change_visibility?

  alias_method :crop_picture?, :edit?
  alias_method :edit_leaders?, :edit?
  alias_method :add_leader?, :edit_leaders?
  alias_method :delete_leader?, :edit_leaders?
  alias_method :delete_volunteer?, :is_admin?


  def is_leader?
    record.has_leader?(user)
  end

  def is_volunteer?(user)
    record.has_volunteer?(user)
  end

  private

  def is_today_or_past?
    today_or_future = nil
    record.days.each do |day|
      today_or_future ||= day.date && (day.date.today? || day.date.past?)
    end
    today_or_future
  end

end
