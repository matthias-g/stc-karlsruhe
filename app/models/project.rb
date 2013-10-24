class Project < ActiveRecord::Base
  attr_accessible :description, :individual_tasks, :name, :requirements

  has_and_belongs_to_many :leaders, :class_name => '::User'
  has_and_belongs_to_many :volunteers, :class_name => '::User'
  has_and_belongs_to_many :project_flags
end
