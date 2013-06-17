Refinery::User.class_eval do

  has_and_belongs_to_many :projects_as_volunteer, :class_name => '::Refinery::Projects::Project' , :join_table => :refinery_projects_volunteers
  has_and_belongs_to_many :projects_as_leader, :class_name => '::Refinery::Projects::Project', :join_table => :refinery_projects_leaders

  belongs_to :image, :class_name => '::Refinery::Image'

  attr_accessible :forename, :surname, :image_id

  validates :forename, :presence => true
  validates :surname, :presence => true

  def leads_project?(project)
    projects_as_leader.any?{|p| p.id == project.id}
  end

end