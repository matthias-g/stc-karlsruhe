class ProjectWeek < ActiveRecord::Base
  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  scope :default, -> { where(default: true).first }

  def active_user_count
    projects.active.joins(:users).select(:user_id).uniq.count
  end

end
