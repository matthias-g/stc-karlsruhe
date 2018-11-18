# TODO move Initiative related methods to respective resource
#      see http://jsonapi-resources.com/v0.9/guide/resources.html#Immutable-Resources

class Api::InitiativeResource < JSONAPI::Resource
  abstract
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements
  attributes :visible, :short_description, :map_latitude, :map_longitude, :map_zoom
  attributes :picture_source, :status
  attribute :picture

  has_one :gallery
  has_many :tags
  has_many :volunteers, class_name: 'User', through: :participations
  has_many :events
  has_many :leaders, class_name: 'User', through: :leaderships

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class).updatable_fields
  end

end
