class Api::TagResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :icon, :color

  has_many :initiatives

  def fetchable_fields
    Pundit.policy(context[:user], @model_class || @model).permitted_attributes_for_show
  end

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class || @model).updatable_fields
  end

end
