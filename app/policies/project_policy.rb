class ProjectPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        or_values = Project.unscoped.visible.where(participations: {as_leader: true})
        scope.where(or_values.where_values_hash.inject(:or)) #TODO: Rails 5
      end
    end
  end

  def show?
    !record.hidden? || edit?
  end

  def edit?
    is_admin? || is_leader?
  end


  def contact_volunteers?
    !record.hidden? && edit?
  end

  def enter?
    !is_volunteer? && record.has_free_places? && !record.finished?
  end

  def leave?
    is_volunteer? && !record.finished?
  end

  def activate?
    edit? && !record.active?
  end

  def close?
    edit? && !record.finished?
  end

  def hide?
    edit? && !record.hidden?
  end


  def upload_pictures?
    !record.hidden? && (is_volunteer? || is_leader? || is_admin? || (user && user.photographer?))
  end

  alias_method :index, :is_admin?
  alias_method :create, :is_admin?

  alias_method :crop_picture?, :edit?
  alias_method :edit_team?, :edit?
  alias_method :add_leader?, :edit_team?
  alias_method :add_volunteer?, :edit_team?
  alias_method :remove_leader?, :is_admin?
  alias_method :remove_volunteer?, :is_admin?


  def is_leader?
    user && (record.has_leader? user)
  end

  def is_volunteer?
    user && (record.has_volunteer? user)
  end

end
