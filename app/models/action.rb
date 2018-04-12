class Action < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, ImageUploader

  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user
  has_many :events, foreign_key: :initiative_id, dependent: :destroy
  accepts_nested_attributes_for :events, allow_destroy: true
  belongs_to :action_group
  has_many :subactions, class_name: 'Action', foreign_key: :parent_action_id
  belongs_to :parent_action, class_name: 'Action', foreign_key: :parent_action_id

  validates_presence_of :title
  validate :parent_action_cannot_be_same_action, :parent_action_cannot_be_a_subaction

  scope :visible,  -> { where(actions: { visible: true }) }
  scope :hidden,   -> { where(actions: { visible: false }) }
  scope :toplevel, -> { where(actions: { parent_action_id: nil }) }
  scope :upcoming, -> { joins(:events).where('events.date >= ?', Date.today) }
  scope :finished, -> { joins(:events).where('events.date < ?', Date.today) }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def leader?(user)
    leaders.include? user
  end

  def add_leader(user)
    leaders << user
  end

  def delete_leader(user)
    leaders.destroy user
  end

  def volunteers
    event_ids = events.map(&:id)
    User.joins(:events_as_volunteer).where(["event_id IN (?)", event_ids])
  end

  def volunteers_in_subactions
    subaction_event_ids = subactions.collect{ |action| action.events.map(&:id) }.flatten
    User.joins(:events_as_volunteer).where(["event_id IN (?)", subaction_event_ids])
  end

  def volunteer?(user)
    events.any? {|event| event.volunteer?(user)}
  end

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  def date
    # TODO other cases
    events.count == 1 ? events.first.date : nil
  end

  def start_time
    # TODO other cases
    events.count == 1 ? events.first.start_time : nil
  end

  # All dates of the action and its sub actions
  # (returns an empty array for undated actions)
  def dates
    dates = subactions.any? ? subactions.collect(&:dates).flatten : []
    dates = dates + events.collect(&:date).flatten
    dates.reject(&:nil?)
  end

  # Number of available volunteer places in this action (without sub actions)
  def available_places
    events.sum(&:available_places)
  end

  def desired_team_size
    events.sum(&:desired_team_size)
  end

  def team_size
    events.map(&:team_size).compact.sum
  end

  # Number of available volunteer places in this action and its sub actions
  def total_available_places
    available_places + subactions.visible.upcoming.sum(&:available_places)
  end

  # Number of reserved volunteer places in this action and its sub actions
  def total_team_size
    team_size + subactions.visible.sum(&:team_size)
  end

  # Number of volunteer places in this action and its sub actions
  def total_desired_team_size
    desired_team_size + subactions.visible.sum(&:desired_team_size)
  end

  # Are the action and its sub actions finished (i.e. in the past)?
  def finished?
    all_dates = dates
    return true unless all_dates.any?
    all_dates.max < Date.today
  end

  # Is the action a sub action?
  def subaction?
    parent_action != nil
  end

  # Title of the action, if applicable prepended with the parent action title
  def full_title
    subaction? ? parent_action.title + ' – ' + title : title
  end

  # Status of the action including its subactions.
  # can be: finished, full, soon_full or empty (i.e. >2 free places)
  def status # TODO test this
    if events.all? { |event| event.finished? } && subactions.all? { |action| action.finished? }
      :finished
    elsif total_available_places.zero?
      :full
    else
      total_available_places < 3 ? :soon_full : :empty
    end
  end

  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def slug_candidates
    candidates = []
    candidates << [full_title]
    candidates << [full_title, action_group.title] if action_group
    candidates
  end

  def parent_action_cannot_be_same_action
    if parent_action == self
      errors.add(:parent_action, "can't be same action")
    end
  end

  def parent_action_cannot_be_a_subaction
    if parent_action&.parent_action
      errors.add(:parent_action, "can't be a subaction itself")
    end
  end

  def on_volunteer_added(user)
    adjust_team_size
    return if finished?
    Mailer.action_participate_volunteer_notification(user, self).deliver_now if user.receive_notifications_for_new_participation
    Mailer.action_participate_leader_notification(user, self).deliver_now
  end

  def on_volunteer_removed(user)
    adjust_team_size
    return if finished?
    Mailer.leaving_action_notification(user, self).deliver_now
  end

end
