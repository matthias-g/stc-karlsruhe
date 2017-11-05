class Api::ProjectWeekResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attribute :title
  attributes :stats
  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  def stats
    {
        'project_count': @model.projects.visible.where.not(desired_team_size: 0).count,
        'active_user_count': @model.active_user_count,
        'vacancy_count': @model.vacancy_count
    }
  end
end
