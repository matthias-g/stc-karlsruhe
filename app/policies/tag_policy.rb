class TagPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def updatable_fields
    return [] unless is_admin_or_coordinator?
    [:title, :initiatives, :icon, :color]
  end

end
