class Surveys::Submission < ApplicationRecord

  belongs_to :template, class_name: 'Surveys::Template'
  has_many :answers, class_name: 'Surveys::Answer', dependent: :destroy
  accepts_nested_attributes_for :answers

  def self.create_for_template template
    submission = new
    submission.template = template
    template.questions.each do |question|
      submission.answers.build(question: question)
    end
    submission
  end

end
