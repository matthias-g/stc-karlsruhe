class Refinery::Projects::Sector < Refinery::Core::BaseModel
  attr_accessible :title
  validates :title, :presence => true, :uniqueness => true

  has_and_belongs_to_many :projects, :class_name => 'Refinery::Projects::Project', :join_table => :refinery_projects_projects_sectors
end
