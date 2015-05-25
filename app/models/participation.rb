class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user, :project

  scope :visible_projects, -> { joins(:project).where(projects: {visible: true}) }

  def self.active_user_count
    visible_projects.select(:user_id).uniq.count
  end

end
