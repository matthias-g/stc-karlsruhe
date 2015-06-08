class Feedback::Survey < ActiveRecord::Base

  has_many :questions, -> { order 'position' }, class_name: 'Feedback::Question', dependent: :destroy
  has_many :survey_answers, :class_name => 'Feedback::SurveyAnswer', dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: lambda { |a| a[:text].blank? }, allow_destroy: true
end
