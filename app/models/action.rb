class Action < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, ImageUploader

  has_many :participations, dependent: :destroy
  has_many :volunteers, class_name: 'User', through: :participations, source: :user,
           after_add: :on_volunteer_added, after_remove: :on_volunteer_removed
  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user
  has_many :events
  belongs_to :action_group
  has_many :subactions, class_name: 'Action', foreign_key: :parent_action_id
  belongs_to :parent_action, class_name: 'Action', foreign_key: :parent_action_id

  validates_presence_of :title, :desired_team_size
  validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :parent_action_cannot_be_same_action, :parent_action_cannot_be_a_subaction

  scope :visible,  -> { where(actions: { visible: true }) }
  scope :hidden,   -> { where(actions: { visible: false }) }
  scope :toplevel, -> { where(actions: { parent_action_id: nil }) }
  scope :active,   -> { where('actions.date >= ?', Date.today) }
  scope :finished, -> { where('actions.date < ?', Date.today) }

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

  def volunteer?(user)
    volunteers.include? user
  end

  def add_volunteer(user)
    volunteers << user
    save
  end

  def delete_volunteer(user)
    volunteers.destroy user
    save
  end

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  # All users who lead the action or one of its sub actions
  def aggregated_leaders
    User.joins(:actions_as_leader).where("(actions.id = #{id || 'NULL'} or parent_action_id = #{id || 'NULL'})")
  end

  # All users who volunteer for the action or one of its sub actions
  def aggregated_volunteers
    User.joins(:actions_as_volunteer).where("(actions.id = #{id || 'NULL'} or parent_action_id = #{id || 'NULL'})")
  end

  # All users who volunteer for one of the sub actions of this action
  def volunteers_in_subactions
    User.joins(:actions_as_volunteer).where("actions.parent_action_id = #{id}")
  end

  # All dates of the action and its sub actions
  # (returns an empty array for undated actions)
  def dates
    dates = subactions.any? ? subactions.collect(&:date) : [date]
    dates.reject(&:nil?)
  end

  # Number of free volunteer places in this action (without sub actions)
  def free_places
    desired_team_size - team_size
  end

  # Number of free volunteer places in this action and its sub actions
  # (includes hidden sub actions only if this action is hidden as well)
  def total_free_places
    free_places + (visible? ? subactions.visible : subactions).active.sum(&:free_places)
  end

  # Number of reserved volunteer places in this action and its sub actions
  # (includes hidden sub actions only if this action is hidden as well)
  def total_team_size
    team_size + (visible? ? subactions.visible : subactions).sum(&:team_size)
  end

  # Number of volunteer places in this action and its sub actions
  # (includes hidden sub actions only if this action is hidden as well)
  def total_desired_team_size
    desired_team_size + (visible? ? subactions.visible : subactions).sum(&:desired_team_size)
  end

  # Are the action and its sub actions finished (i.e. in the past)?
  # (Note: undated actions are never finished)
  def finished?
    all_dates = dates
    !(all_dates.any? && all_dates.max >= Date.today)
  end

  # Is the action a sub action?
  def subaction?
    parent_action != nil
  end

  TIME_REGEX = /(\d{1,2})[:\.-]?(\d{1,2})?[^\d\/]*(\d{1,2})?[:\.-]?(\d{1,2})?.*/

  # Start time of the action, parsed from the time string
  def start_time
    return nil unless date
    day = date
    return nil unless time
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[1], min: matches[2], year: day.year, month: day.month, day: day.day) if matches
  end

  # End time of the action, parsed from the time string
  def end_time
    return nil unless date
    day = date
    return nil unless time
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[3], min: matches[4], year: day.year, month: day.month, day: day.day) if matches && matches[3]
  end

  # Title of the action, if applicable prepended with the parent action title
  def full_title
    subaction? ? parent_action.title + ': ' + title : title
  end

  # Status of the action including its subactions.
  # can be: finished, full, soon_full or empty (i.e. >2 free places)
  def status
    if finished?
      :finished
    elsif total_free_places.zero?
      :full
    else
      total_free_places < 3 ? :soon_full : :empty
    end
  end


  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def slug_candidates
    candidates = []
    candidates << [full_title]
    candidates << [:title, action_group.title] if action_group
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
    self.team_size = volunteers.count
    parent_action&.on_volunteer_added(user)
    return if finished?
    Mailer.action_participate_volunteer_notification(user, self).deliver_now if user.receive_notifications_for_new_participation
    Mailer.action_participate_leader_notification(user, self).deliver_now
  end

  def on_volunteer_removed(user)
    self.team_size = volunteers.count
    parent_action&.on_volunteer_removed(user)
    return if finished?
    Mailer.leaving_action_notification(user, self).deliver_now
  end

end
