class RolePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
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
    is_admin?
  end

  def edit?
    is_admin?
  end

  alias update? edit?
  alias destroy? edit?

end
