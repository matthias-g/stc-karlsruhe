class ProjectWeek < ActiveRecord::Base
  validates_uniqueness_of :title

  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  scope :default, -> { where(default: true).first }

  def active_user_count
    projects.visible.joins(:users).select(:user_id).uniq.count
  end

end
