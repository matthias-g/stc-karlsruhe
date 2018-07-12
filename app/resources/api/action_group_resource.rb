class Api::ActionGroupResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :start_date, :end_date, :default, :declination
  has_many :actions

  def fetchable_fields
    Pundit.policy(context[:user], @model).permitted_attributes_for_show
  end

end
