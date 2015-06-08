class Feedback::Survey < ActiveRecord::Base

  has_many :questions, -> { order 'position' }, class_name: 'Feedback::Question', dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: lambda { |a| a[:text].blank? }, allow_destroy: true
end
