class GalleryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def user_is_admin?
    return false unless user
    user.admin?
  end

  alias_method :index?, :user_is_admin?
  alias_method :show?, :user_is_admin?
  alias_method :new?, :user_is_admin?
  alias_method :edit?, :user_is_admin?
  alias_method :create?, :user_is_admin?
  alias_method :destroy?, :user_is_admin?
  alias_method :make_all_visible?, :user_is_admin?
  alias_method :make_all_invisible?, :user_is_admin?

  def update?
    return false unless user
    return true if user.admin? || user.photographer?
    record.projects.each do |project|
      return false unless Pundit.policy!(user, project).upload_pictures?
    end
    true
  end

end
