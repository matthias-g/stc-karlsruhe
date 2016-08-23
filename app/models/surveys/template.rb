class Surveys::Template < ApplicationRecord

  has_many :questions, -> { order 'position' }, class_name: 'Surveys::Question', dependent: :destroy
  has_many :submissions, :class_name => 'Surveys::Submission', dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: lambda { |a| a[:text].blank? }, allow_destroy: true

  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end
