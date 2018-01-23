class ActionGroup < ApplicationRecord
  validates_uniqueness_of :title

  has_many :actions

  validates_presence_of :start_date, :end_date

  scope :default, -> { where(default: true).first }

  def active_user_count
    User.joins('LEFT JOIN "participations" ON "participations"."user_id" = "users"."id"')
        .joins('LEFT JOIN "leaderships" ON "leaderships"."user_id" = "users"."id"')
        .joins('INNER JOIN "actions" ON "actions"."id" = "leaderships"."action_id" OR "actions"."id" = "participations"."action_id"')
        .where('actions.visible': true).where('actions.action_group_id': self.id).distinct.count
  end

  def vacancy_count
    actions.active.to_a.select{|p| p.subactions.count == 0}.map{|p| p.aggregated_desired_team_size - p.aggregated_volunteers.count}.sum
  end

  def date_range
    start_date..end_date
  end

end
