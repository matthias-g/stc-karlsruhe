class OrgaMessagePolicy < ApplicationPolicy

  def update?
    index? && !record.sent?
  end

  def destroy?
    update? || is_admin?
  end

  alias_method :index?, :is_admin_or_coordinator?
  alias_method :new?, :index?
  alias_method :show?, :index?
  alias_method :create?, :index?

  alias_method :edit?, :update?
  alias_method :send_message?, :update?

end
