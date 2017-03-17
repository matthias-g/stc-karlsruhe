class UserPolicy < ApplicationPolicy

  include ProjectUserRelationship

  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    is_admin?
  end

  def show?
    return false unless user
    !record.cleared? || is_admin?
  end

  def permitted_attributes_for_show
    return [:first_name] unless user
    return [:first_name, :last_name] unless user.eql?(record) || user.admin?
    [:username, :first_name, :last_name, :email, :phone,
        :receive_emails_about_project_weeks, :receive_emails_about_my_project_weeks, :receive_emails_about_other_projects,
        :receive_other_emails_from_orga, :receive_emails_from_other_users]
  end

  def edit?
    return false unless user
    user.eql?(record) || is_admin?
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :confirm_delete?, :destroy?

  def contact_user?
    return false unless user
    true
  end

  def add_to_projects_as_volunteer?(projects)
    projects.all? { |project| allow_add_volunteer_to_project?(record, project) }
  end

  def add_to_roles?(_role)
    is_admin?
  end

end
