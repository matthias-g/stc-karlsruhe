class Surveys::Submission < ActiveRecord::Base

  belongs_to :template, class_name: 'Surveys::Template'
  has_many :answers, class_name: 'Surveys::Answer', dependent: :destroy
  accepts_nested_attributes_for :answers

end
