json.array!(@feedback_survey_answers) do |feedback_survey_answer|
  json.extract! feedback_survey_answer, :id, :survey_id
  json.url feedback_survey_answer_url(feedback_survey_answer, format: :json)
end
