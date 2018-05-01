class GalleryPolicy < ApplicationPolicy

  class Scope < Scope
  end


  def show?
    GalleryPicturePolicy::Scope.new(user, record.gallery_pictures).resolve.count.positive? || is_admin?
  end

  def update?
    return false unless user
    return true if user.admin? || user.photographer?
    return false if record.actions.empty?
    record.actions.all? { |action| Pundit.policy!(user, action).upload_pictures? }
  end


  alias_method :index?, :is_admin?
  alias_method :new?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :destroy?, :is_admin?
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :make_all_visible?, :edit?
  alias_method :make_all_invisible?, :edit?

end
