class Api::SubscriptionResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :email, :name
  attributes :receive_emails_about_action_groups, :receive_emails_about_other_projects, :receive_other_emails_from_orga

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class).updatable_fields
  end

end
