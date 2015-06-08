json.array!(@feedback_questions) do |feedback_question|
  json.extract! feedback_question, :id, :survey_id, :text, :answer_options, :type, :position, :parent_question_id
  json.url feedback_question_url(feedback_question, format: :json)
end
