class ProjectPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(Project.unscoped.where(visible: true, participations: {as_leader: true}).where_values_hash.inject(:or)) # TODO Rails 5
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
    !is_volunteer? && record.has_free_places? && !record.closed?
  end

  def leave?
    is_volunteer? && !record.closed?
  end

  def upload_pictures?
    record.visible? && is_today_or_past? && (is_volunteer? || is_leader? || is_admin? || (user && user.photographer?))
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
    user && (record.has_leader? user)
  end

  def is_volunteer?
    user && (record.has_volunteer? user)
  end

  private

  def is_today_or_past?
    today_or_future = false
    record.days.each do |day|
      today_or_future ||= day.date && (day.date.today? || day.date.past?)
    end
    today_or_future
  end

end
