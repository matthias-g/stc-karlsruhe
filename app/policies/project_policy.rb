class ProjectPolicy < ApplicationPolicy

  def index?
    return false unless user
    user.admin?
  end

  def create?
    return false unless user
    user.admin?
  end

  def show?
    return true if record.visible?
    return false unless user
    user.admin? || user.leads_project?(record)
  end

  def edit?
    return false unless user
    user.admin? || user.leads_project?(record)
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :edit_leaders?, :edit?
  alias_method :add_leader?, :edit_leaders?
  alias_method :delete_leader?, :edit_leaders?
  alias_method :open?, :edit?
  alias_method :close?, :edit?
  alias_method :crop_picture?, :edit?
  alias_method :contact_volunteers?, :edit?

  def enter?
    return false unless user
    record.visible? && !record.full? && !record.closed? && !record.has_volunteer?(user)
  end

  def leave?
    return false unless user
    record.visible? && !record.closed? && record.has_volunteer?(user)
  end

  def delete_volunteer?
    return false unless user
    user.admin?
  end

  def change_visibility?
    return false unless user
    user.admin?
  end

  alias_method :make_visible?, :change_visibility?
  alias_method :make_invisible?, :change_visibility?

  def upload_pictures?
    return false unless user
    record.has_volunteer?(user) || record.has_leader?(user) || user.admin? || user.photographer?
  end

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(Project.unscoped.where(visible: true, participations: {as_leader: true}).where_values_hash.inject(:or)) # TODO Rails 5
      end
    end
  end

end
