class Api::TagResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :icon, :color

  has_many :initiatives

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model).updatable_fields
  end

end
