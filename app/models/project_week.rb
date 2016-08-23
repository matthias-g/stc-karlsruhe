class ProjectWeek < ApplicationRecord
  validates_uniqueness_of :title

  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  scope :default, -> { where(default: true).first }

  def active_user_count
    projects.visible.joins(:users).select(:user_id).distinct.count
  end

  def vacancy_count
    projects.active.toplevel.map{|p| p.aggregated_desired_team_size - p.aggregated_volunteers.count}.sum
  end

  def date_range
    default = Date.new(1970, 1, 1)
    return default..default if days.empty?
    min = max = days.first.date
    days.each do |day|
      d = day.date
      return default..default if d.blank?
      min = d if d < min
      max = d if d > max
    end
    return min..max
  end

end
