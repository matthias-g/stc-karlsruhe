class RolePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.none
    end
  end

  alias_method :index?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :show?, :is_admin?
  alias_method :edit?, :is_admin?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

end
