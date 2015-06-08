class Feedback::Question < ActiveRecord::Base

  belongs_to :survey, class_name: 'Feedback::Survey'
  has_many :answers, class_name: 'Feedback::Answer', dependent: :destroy
end
