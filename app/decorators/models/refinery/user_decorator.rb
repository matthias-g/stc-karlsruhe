module Refinery
  User.class_eval do

    has_and_belongs_to_many :projects_as_volunteer, :class_name => '::Refinery::Projects::Project' , :join_table => :refinery_projects_volunteers
    has_and_belongs_to_many :projects_as_leader, :class_name => '::Refinery::Projects::Project', :join_table => :refinery_projects_leaders

    belongs_to :image

    attr_accessible :forename, :surname, :image_id

    validates :forename, :presence => true
    validates :surname, :presence => true

    def leads_project?(project)
      projects_as_leader.any?{|p| p.id == project.id}
    end

    def create_volunteer
      if valid?
        save
        add_role(:volunteer)
      end

      # return true/false based on validations
      valid?
    end

    def is_admin?
      has_role?(:refinery) && has_role?(:superuser)
    end

  end
end
