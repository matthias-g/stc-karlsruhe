class Surveys::Question < ApplicationRecord

  belongs_to :template, class_name: 'Surveys::Template', inverse_of: :questions
  has_many :answers, class_name: 'Surveys::Answer', dependent: :destroy
  validates_presence_of :template

  enum question_type: { text: 1, choice: 2, choice_or_text: 3, text_line: 4, info: 5 }

end
