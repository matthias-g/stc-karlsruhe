class Api::ActionResource < Api::InitiativeResource

  attribute :info
  has_one :action_group
  has_one :parent_action, class_name: 'Action', custom_methods: { apply_join: -> (options) {
    # workaround: jsonapi-resources fails to set the correct secondary table alias for self-joined relationships
    options[:table_alias] = 'parent_actions_initiatives'
    options[:records].joins(:parent_action).references('parent_actions_initiatives')
  }}

  filter :action_group
  filter :scope, apply: -> (records, value, _options) {
    allowed = [:toplevel, :visible, :hidden, :upcoming, :finished]
    scopes = value[0].is_a?(Array) ? value[0] : [value[0]]
    scopes.each do |scope|
      records = records.public_send(scope) if allowed.include?(scope.to_sym)
    end
    records
  }

  def info
    {
      toplevel: !@model.subaction?,
      status: @model.status,
      team_size: @model.total_team_size,
      desired_team_size: @model.total_desired_team_size,
      subaction_count: @model.subaction_count,
      url: Rails.application.routes.url_helpers.action_path(@model),
      teaser: @model.short_description.presence || @model.description,
      work_friendly: @model.all_events.any?(&:work_friendly?),
      dates: @model.all_dates.map{|date| date.strftime("%Y-%m-%d")}
    }
  end

end
