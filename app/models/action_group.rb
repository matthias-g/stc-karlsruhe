class ActionGroup < ApplicationRecord
  validates_uniqueness_of :title

  has_many :actions

  validates_presence_of :start_date, :end_date
  enum declination: [:m_sg, :m_pl, :f_sg, :f_pl]

  scope :default, -> { where(default: true).first }
  scope :upcoming, -> { where('end_date >= ?', Date.current).order(:start_date) }
  scope :newest, -> { order(start_date: :desc) }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def active_user_count
    # TODO: this is still slow
    User.left_outer_joins(:initiatives_as_leader, events_as_volunteer: :initiative)
        .where('initiatives.visible OR initiatives_events.visible')
        .where('initiatives.action_group_id = ? OR initiatives_events.action_group_id = ?', self.id, self.id)
        .distinct.count
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
