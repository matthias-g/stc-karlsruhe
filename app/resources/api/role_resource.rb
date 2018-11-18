class Api::RoleResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title

  has_many :users

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class).updatable_fields
  end

end
