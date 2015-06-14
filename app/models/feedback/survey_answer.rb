class Feedback::SurveyAnswer < ActiveRecord::Base

  belongs_to :survey, class_name: 'Feedback::Survey'
  has_many :answers, class_name: 'Feedback::Answer', dependent: :destroy
  accepts_nested_attributes_for :answers

end
