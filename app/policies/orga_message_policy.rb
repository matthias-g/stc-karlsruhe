class OrgaMessagePolicy < ApplicationPolicy

  def index?
    is_admin? || is_coordinator?
  end

  def update?
    (is_admin? || is_coordinator?) && !record.sent?
  end

  alias_method :new?, :index?
  alias_method :show?, :index?
  alias_method :create?, :index?
  alias_method :edit?, :index?
  alias_method :destroy?, :update?
  alias_method :send_message?, :update?

end
