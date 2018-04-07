class ActionGroupPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    is_admin?
  end

  def create?
    is_admin?
  end

  def show?
    true
  end

  def edit?
    is_admin?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

end
