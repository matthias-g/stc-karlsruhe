class ProjectDay < ApplicationRecord
  has_and_belongs_to_many :projects
  belongs_to :project_week
end
