class ProjectWeek < ApplicationRecord
  validates_uniqueness_of :title

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
    start_date..end_date
  end

end
