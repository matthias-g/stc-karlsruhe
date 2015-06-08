json.array!(@surveys) do |feedback_survey|
  json.extract! feedback_survey, :id, :title
  json.url feedback_survey_url(feedback_survey, format: :json)
end
