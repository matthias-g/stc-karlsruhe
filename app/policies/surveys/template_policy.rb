class Surveys::TemplatePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && (user.admin? || user.coordinator?)
        scope.all
      else
        scope.none
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
    is_admin? || is_coordinator?
  end

  def edit?
    is_admin? || is_coordinator?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

end
