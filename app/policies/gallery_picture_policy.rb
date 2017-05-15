class GalleryPicturePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user && (user.admin? || user.coordinator?)
        scope.all
      else
        scope.where(visible: true).or(scope.where(uploader: user))
      end
    end
  end

  def index?
    true
  end

  def create?
    is_admin?
  end

  def show?
    is_admin_or_coordinator? || record.visible || is_uploader?
  end

  def permitted_attributes_for_show
    public_attributes = [:width, :height, :desktop_width, :desktop_height, :picture, :editable]
    return public_attributes unless is_admin?
    public_attributes + [:visible, :uploader]
  end

  def edit?
    is_admin? || is_coordinator?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  def make_visible?
    is_admin_or_coordinator?
  end

  def make_invisible?
    is_admin_or_coordinator? || is_uploader?
  end

  def is_uploader?
    user.eql?(record.uploader)
  end


end
