class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user, :project

  scope :active_projects, -> { joins(:project).where.not(projects: {status: 'closed'}).where(projects: {visible: true}) }

  def self.active_user_count
    active_projects.select(:user_id).uniq.count
  end

end
