class Api::SubscriptionResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :email, :name
  attributes :receive_emails_about_action_groups, :receive_emails_about_other_projects, :receive_other_emails_from_orga

end
