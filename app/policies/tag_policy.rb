class TagPolicy < ApplicationPolicy

  class Scope < Scope
  end

  alias_method :show?, :always
  alias_method :index?, :always
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  def permitted_attributes_for_show
    [:title, :initiatives, :icon, :color]
  end

  def updatable_fields
    return [] unless is_admin_or_coordinator?
    [:title, :initiatives, :icon, :color]
  end

end
