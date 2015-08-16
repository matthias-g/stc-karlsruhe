class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    return false unless user
    user.is_admin?
  end

  def show?
    return false unless user
    !user.cleared? || user.is_admin?
  end

  def edit?
    return false unless user
    user == record || user.is_admin?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :confirm_delete?, :destroy?

  def contact_user?
    return false unless user
    true
  end

end
