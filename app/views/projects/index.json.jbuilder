json.array!(@projects) do |project|
  json.extract! project, :id, :title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements, :visible
  json.url project_url(project, format: :json)
end
