class GalleryPolicy < ApplicationPolicy

  class Scope < Scope
  end


  def show?
    is_admin? || GalleryPicturePolicy::Scope.new(user, record.gallery_pictures).resolve.count.positive?
  end

  def update?
    return nil unless user
    return true if user.admin? || user.photographer?
    return nil unless record.owner
    Pundit.policy!(user, record.owner).upload_pictures?
  end

  alias_method :index?, :is_admin?
  alias_method :new?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :destroy?, :is_admin?
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :make_all_visible?, :edit?
  alias_method :make_all_invisible?, :edit?

end
