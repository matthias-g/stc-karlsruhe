json.array!(@project_days) do |project_day|
  json.extract! project_day, :id, :title
  json.url project_day_url(project_day, format: :json)
end
