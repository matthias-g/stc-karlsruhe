class ApplicationPolicy
  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end


  def initialize(user, record)
    @user = user
    @record = record
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end


  def index?
    false
  end

  def show?
    scope.where(id: record).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end


  def is_admin?
    user&.admin?
  end

  def is_coordinator?
    user&.coordinator?
  end

  def is_admin_or_coordinator?
    user&.in_orga_team?
  end

  def always
    true
  end

end
