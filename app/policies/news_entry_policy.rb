class NewsEntryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    return true
  end

  def show?
    record.visible? || (user && user.admin?)
  end

  def edit?
    user && user.admin?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :crop_picture?, :edit?
  alias_method :upload_pictures?, :edit?

end
