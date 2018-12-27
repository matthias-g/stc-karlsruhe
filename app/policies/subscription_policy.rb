class SubscriptionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      return scope.none unless user
      if user.admin? || user.coordinator?
        scope.all
      else
        scope.where(email: user.email)
      end
    end
  end

  def create?
    true
  end

  def edit?
    return nil unless user
    record.email.eql?(user.email)
  end

  alias_method :index?, :is_admin?
  alias_method :show?, :edit?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

end
