class GalleryPicturePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(visible: true)
      end
    end
  end

  def index?
    is_admin?
  end

  def create?
    is_admin?
  end

  def show?
    is_admin? || record.visible || is_uploader?
  end

  def edit?
    is_admin?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  def is_uploader?
    user && record.uploader == user
  end


end
