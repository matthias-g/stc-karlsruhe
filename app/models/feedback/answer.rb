class Feedback::Answer < ActiveRecord::Base

  belongs_to :question, class_name: 'Feedback::Question'
  belongs_to :survey_answer, class_name: 'Feedback::SurveyAnswer'

  default_scope {joins(:question).order('feedback_questions.position')}
end
