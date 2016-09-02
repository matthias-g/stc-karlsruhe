class Surveys::SubmissionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    is_admin?
  end

  def create?
    true
  end

  def show?
    is_admin?
  end

  def edit?
    false
  end

  alias_method :update?, :edit?

  def destroy?
    is_admin?
  end

end
