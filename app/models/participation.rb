class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user, :project

  def self.active
    Participation.joins(:project).where.not(projects: {status: 'closed'}).where(projects: {visible: true})
  end

  def self.active_user_count
    active.select(:user_id).uniq.count
  end

end
