class Api::ProjectWeekResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attribute :title
  has_many :projects
end
