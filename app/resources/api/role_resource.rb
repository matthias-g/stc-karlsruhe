class Api::RoleResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title

  has_many :users

end
