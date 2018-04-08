class Api::ActionGroupResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attribute :title
  attributes :stats
  has_many :actions

  def stats
    {
        'action_count': @model.actions.visible.count,
        'active_user_count': @model.active_user_count,
        'vacancy_count': @model.vacancy_count
    }
  end
end
