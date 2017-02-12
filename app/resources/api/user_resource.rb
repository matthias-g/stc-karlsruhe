class Api::UserResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :username, :first_name, :last_name, :email, :phone

  def fetchable_fields
    Pundit.policy(context[:user], @model).permitted_attributes_for_show
  end

  has_many :projects_as_volunteer, class_name: 'Project', through: :participations, # inverse_relationship: :volunteers,
           always_include_linkage_data: false

end
