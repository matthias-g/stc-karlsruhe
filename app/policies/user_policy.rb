class UserPolicy < ApplicationPolicy

  include ActionUserRelationship

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
        :receive_emails_about_action_groups, :receive_emails_about_my_action_groups, :receive_emails_about_other_projects,
        :receive_other_emails_from_orga, :receive_emails_from_other_users]
  end

  def edit?
    return false unless user
    user.eql?(record) || is_admin?
  end

  def updatable_fields
    return [:actions_as_volunteer, :username, :first_name, :last_name, :email, :phone] unless is_admin?
    [:roles, :actions_as_volunteer, :username, :first_name, :last_name, :email, :phone]
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :confirm_delete?, :destroy?

  def contact_user?
    return false unless user
    true
  end

  def add_to_actions_as_volunteer?(actions)
    actions.all? { |action| allow_add_volunteer_to_action?(record, action) }
  end

end
