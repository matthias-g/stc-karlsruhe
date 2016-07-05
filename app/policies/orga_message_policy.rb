class OrgaMessagePolicy < ApplicationPolicy

  def index?
    is_admin?
  end

  def update?
    is_admin? && !record.sent?
  end

  alias_method :new?, :index?
  alias_method :create?, :index?
  alias_method :edit?, :index?
  alias_method :destroy?, :index?
  alias_method :send_message?, :update?

end
