class Api::UserResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  has_many :actions_as_volunteer, class_name: 'Action', through: :participations, always_include_linkage_data: false
  has_many :roles

  attributes :username, :first_name, :last_name, :email, :phone

  filter :cleared

  def fetchable_fields
    Pundit.policy(context[:user], @model_class).permitted_attributes_for_show
  end

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class).updatable_fields
  end

end
