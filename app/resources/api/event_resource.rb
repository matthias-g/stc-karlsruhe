module Api
  class EventResource < JSONAPI::Resource
    include JSONAPI::Authorization::PunditScopedResource

    attributes :desired_team_size, :team, :date, :team_size

    has_one :initiative
    has_many :volunteers, class_name: 'User', through: :participations

    def self.updatable_fields(context)
      Pundit.policy(context[:user], @model).updatable_fields
    end

  end
end
