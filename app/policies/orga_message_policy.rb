class OrgaMessagePolicy < ApplicationPolicy

  def index?
    is_admin? || is_coordinator?
  end

  def update?
    (is_admin? || is_coordinator?) && !record.sent?
  end

  alias new? index?
  alias show? index?
  alias create? index?
  alias edit? index?
  alias destroy? update?
  alias send_message? update?

end
