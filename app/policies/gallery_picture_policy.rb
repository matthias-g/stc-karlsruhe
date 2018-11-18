class GalleryPicturePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      user&.in_orga_team? ? scope.all : scope.where(visible: true).or(scope.where(uploader: user))
    end
  end

  def make_invisible?
    is_admin_or_coordinator? || is_uploader?
  end


  alias_method :index?, :always
  alias_method :create?, :is_admin?
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :make_visible?, :is_admin_or_coordinator?


  def permitted_attributes_for_show
    public_attributes = %i[width height desktop_width desktop_height picture editable]
    return public_attributes unless is_admin?
    public_attributes + %i[visible uploader]
  end


  private

  def is_uploader?
    user.eql?(record.uploader)
  end


end
