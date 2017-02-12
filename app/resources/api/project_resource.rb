module Api
  class ProjectResource < JSONAPI::Resource
    include JSONAPI::Authorization::PunditScopedResource

    attributes :title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements
    attributes :visible, :desired_team_size, :time, :short_description, :map_latitude, :map_longitude, :map_zoom
    attributes :picture_source, :status
    attribute :picture

    has_one :project_week
    has_one :parent_project, class_name: 'Project'
    has_one :gallery
    has_many :volunteers, class_name: 'User', through: :participations, inverse_relationship: :projects_as_volunteer, always_include_linkage_data: true
    has_many :leaders, class_name: 'User', through: :leaderships, always_include_linkage_data: true

  end
end
