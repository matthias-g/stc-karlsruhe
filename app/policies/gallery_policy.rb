class GalleryPolicy < ApplicationPolicy

  class Scope < Scope
  end


  def show?
    is_admin? || show_gallery_partial?
  end

  def update?
    return false unless user
    return true if user.admin? || user.photographer?
    return false if record.actions.empty?
    record.actions.all? { |action| Pundit.policy!(user, action).upload_pictures? }
  end

  def show_gallery_partial?
    GalleryPicturePolicy::Scope.new(user, record.gallery_pictures).resolve.count.positive?
  end

  def show_invisible_pictures_notification?
    return false unless user
    record.gallery_pictures.invisible.where(uploader_id: user.id).any? ||
        (is_admin_or_coordinator? && record.gallery_pictures.invisible.any?)
  end

  alias_method :index?, :is_admin?
  alias_method :new?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :destroy?, :is_admin?
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :make_all_visible?, :edit?
  alias_method :make_all_invisible?, :edit?

end
