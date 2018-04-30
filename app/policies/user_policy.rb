class UserPolicy < ApplicationPolicy

  include EventUserRelationship

  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return nil unless user
    !record.cleared? || is_admin?
  end

  def permitted_attributes_for_show
    return %i[first_name] unless user
    return %i[first_name last_name] unless user.eql?(record) || user.admin?
    %i[username first_name last_name email phone
       receive_emails_about_action_groups
       receive_emails_about_my_action_groups
       receive_emails_about_other_projects
       receive_other_emails_from_orga
       receive_emails_from_other_users]
  end

  def edit?
    user.eql?(record) || is_admin?
  end

  def updatable_fields
    return %i[actions_as_volunteer username first_name last_name email phone] unless is_admin?
    %i[roles actions_as_volunteer username first_name last_name email phone]
  end

  alias_method :index?, :is_admin_or_coordinator?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :confirm_delete?, :destroy?

  def contact_user?
    return nil unless user
    true
  end

end
