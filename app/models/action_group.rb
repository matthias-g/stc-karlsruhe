class ActionGroup < ApplicationRecord
  validates_uniqueness_of :title

  has_many :actions

  validates_presence_of :start_date, :end_date

  scope :default, -> { where(default: true).first }
  scope :upcoming, -> { where('end_date >= ?', Date.today).order(:start_date) }
  scope :newest, -> { order(start_date: :desc) }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def active_user_count
    User.joins('LEFT JOIN "participations" ON "participations"."user_id" = "users"."id"')
        .joins('LEFT JOIN "leaderships" ON "leaderships"."user_id" = "users"."id"')
        .joins('LEFT JOIN "events" ON "events"."id" = "participations"."event_id"')
        .joins('INNER JOIN "actions" ON "actions"."id" = "leaderships"."action_id" OR "actions"."id" = "events"."initiative_id"')
        .where('actions.visible': true).where('actions.action_group_id': self.id).distinct.count
  end

  def vacancy_count
    actions.visible.upcoming.sum(&:available_places)
  end

  def date_range
    start_date..end_date
  end

  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def slug_candidates
    candidates = []
    candidates << [title]
    candidates << [title, start_date.year]
    candidates
  end
end
