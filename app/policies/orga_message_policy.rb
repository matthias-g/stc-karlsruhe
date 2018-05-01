class OrgaMessagePolicy < ApplicationPolicy

  def update?
    edit? && !record.sent?
  end

  alias_method :index?, :is_admin_or_coordinator?
  alias_method :new?, :index?
  alias_method :show?, :index?
  alias_method :create?, :index?
  alias_method :edit?, :index?
  alias_method :destroy?, :update?
  alias_method :send_message?, :update?

end
