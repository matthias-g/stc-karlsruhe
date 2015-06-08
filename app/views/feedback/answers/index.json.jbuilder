json.array!(@feedback_answers) do |feedback_answer|
  json.extract! feedback_answer, :id, :survey_answer_id, :question_id, :text
  json.url feedback_answer_url(feedback_answer, format: :json)
end
