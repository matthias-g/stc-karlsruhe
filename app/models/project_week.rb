class ProjectWeek < ActiveRecord::Base
  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  scope :default, -> { where(default: true).first }
end
