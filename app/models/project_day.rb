class ProjectDay < ActiveRecord::Base
  has_and_belongs_to_many :projects
  belongs_to :project_week
end
