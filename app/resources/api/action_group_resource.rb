class Api::ActionGroupResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :start_date, :end_date, :default, :declination
  has_many :actions

end
