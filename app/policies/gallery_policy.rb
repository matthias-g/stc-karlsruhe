class GalleryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    GalleryPicturePolicy::Scope.new(user, record.gallery_pictures).resolve.count.positive? || is_admin?
  end

  alias index? is_admin?
  alias new? is_admin?
  alias edit? is_admin_or_coordinator?
  alias create? is_admin?
  alias destroy? is_admin?
  alias make_all_visible? is_admin_or_coordinator?
  alias make_all_invisible? is_admin_or_coordinator?

  def update?
    return false unless user
    return true if user.admin? || user.photographer?
    record.actions.all? { |action| Pundit.policy!(user, action).upload_pictures? }
  end

end
