class Api::ProjectDayResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :date
  has_one :project_week
end
