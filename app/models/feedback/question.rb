class Feedback::Question < ActiveRecord::Base

  belongs_to :survey, class_name: 'Feedback::Survey'
  has_many :answers, class_name: 'Feedback::Answer', dependent: :destroy

  enum question_type: { text: 1, choice: 2, choice_or_text: 3 }

end
