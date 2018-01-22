class ProjectWeek < ApplicationRecord
  validates_uniqueness_of :title

  has_many :days, class_name: 'ProjectDay'
  has_many :projects

  validates_presence_of :start_date, :end_date

  scope :default, -> { where(default: true).first }

  def active_user_count
    User.joins('LEFT JOIN "participations" ON "participations"."user_id" = "users"."id"')
        .joins('LEFT JOIN "leaderships" ON "leaderships"."user_id" = "users"."id"')
        .joins('INNER JOIN "projects" ON "projects"."id" = "leaderships"."project_id" OR "projects"."id" = "participations"."project_id"')
        .where('projects.visible': true).where('projects.project_week_id': self.id).distinct.count
  end

  def vacancy_count
    projects.active.to_a.select{|p| p.subprojects.count == 0}.map{|p| p.aggregated_desired_team_size - p.aggregated_volunteers.count}.sum
  end

  def date_range
    if start_date && end_date
      return start_date..end_date
    end
    # TODO delete:
    default = Date.new(1970, 1, 1)
    return default..(default+1) if days.empty?
    min = max = days.first.date
    days.each do |day|
      d = day.date
      return default..(default+1) if d.blank?
      min = d if d < min
      max = d if d > max
    end
    return min..max
  end

end
