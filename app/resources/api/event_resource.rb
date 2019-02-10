class Api::EventResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :date, :time, :start_time, :end_time, :desired_team_size, :team_size

  has_one :initiative
  has_many :volunteers, class_name: 'User', through: :participations

  def self.updatable_fields(context)
    Pundit.policy(context[:user], @model_class || @model).updatable_fields
  end
end
