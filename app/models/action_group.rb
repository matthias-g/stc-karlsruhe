class ActionGroup < ApplicationRecord


  has_many :actions, after_add: :update_cache_fields, after_remove: :update_cache_fields

  validates_uniqueness_of :title
  validates_presence_of :start_date, :end_date
  enum declination: [:m_sg, :m_pl, :f_sg, :f_pl]

  scope :default, -> { where(default: true).first }
  scope :upcoming, -> { where('end_date >= ?', Date.current).order(:start_date) }
  scope :newest, -> { order(start_date: :desc) }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def date_range
    start_date..end_date
  end

  def update_cache_fields(*args)
    self.action_count = actions.visible.count
    self.active_user_count = User.left_outer_joins(:initiatives_as_leader, events_as_volunteer: :initiative)
                                 .where('initiatives.visible OR initiatives_events.visible')
                                 .where('initiatives.action_group_id = ? OR initiatives_events.action_group_id = ?', self.id, self.id)
                                 .distinct.count
    self.available_places_count = actions.visible.upcoming.sum(&:available_places)
    save if changed?
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
