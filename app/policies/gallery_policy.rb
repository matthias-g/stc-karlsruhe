class GalleryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    GalleryPicturePolicy::Scope.new(user, record.gallery_pictures).resolve.count.positive? || is_admin?
  end

  alias_method :index?, :is_admin?
  alias_method :new?, :is_admin?
  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :create?, :is_admin?
  alias_method :destroy?, :is_admin?
  alias_method :make_all_visible?, :is_admin_or_coordinator?
  alias_method :make_all_invisible?, :is_admin_or_coordinator?

  def update?
    return false unless user
    return true if user.admin? || user.photographer?
    return false if record.actions.empty?
    record.actions.all? { |action| Pundit.policy!(user, action).upload_pictures? }
  end

end
