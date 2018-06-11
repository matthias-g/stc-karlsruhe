class Event < ApplicationRecord

  belongs_to :initiative, class_name: 'Initiative'

  has_many :participations, dependent: :destroy, counter_cache: :team_size
  has_many :volunteers, class_name: 'User', through: :participations, source: :user,
           after_add: :on_volunteer_added, after_remove: :on_volunteer_removed

  validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates_presence_of :date

  before_save :set_datetime_fields

  scope :upcoming, -> { where('events.end_time >= ?', Time.now).order(date: :asc) }
  scope :today_or_past, -> { where('events.date <= ?', Date.current).order(date: :asc) }
  scope :finished, -> { where('events.end_time < ?', Time.now).order(date: :desc) }
  scope :recent,   -> { where('events.date > ?', 1.year.ago).order(date: :desc) }


  def add_volunteer(user)
    volunteers << user
    save
  end

  def delete_volunteer(user)
    volunteers.destroy user
    save
  end

  def volunteer?(user)
    volunteers.include? user
  end

  def available_places
    finished? ? 0 : (desired_team_size - team_size)
  end

  def finished?
    date.nil? || (end_time < Time.now) || (date < Date.current)
  end

  def status
    if finished?
      :finished
    elsif team_size == desired_team_size
      :full
    else
      (desired_team_size - team_size) < 3 ? :soon_full : :empty
    end
  end

  private

  def on_volunteer_added(user)
    return if finished?
    if user.receive_notifications_for_new_participation
      Mailer.event_join_reminder(user, self).deliver_later
    end
    recipients = initiative.leaders.where(receive_notifications_about_volunteers: true)
    return if recipients.blank?
    recipients.uniq.each do |recipient|
      Mailer.event_join_notification(recipient, user, self).deliver_later
    end
  end

  def on_volunteer_removed(user)
    return if finished?
    recipients = initiative.leaders.where(receive_notifications_about_volunteers: true)
    recipients.uniq.each do |recipient|
      Mailer.event_leave_notification(recipient, user, self).deliver_later
    end
  end

  def set_datetime_fields
    self.start_time = parse_start_time || self.date.at_beginning_of_day
    self.end_time = parse_end_time || parse_start_time&.advance(hours: 4) || self.date.at_end_of_day
  end

  TIME_REGEX = /(\d{1,2})[:\.]?(\d{1,2})?[^\d\/]*(\d{1,2})?[:\.-]?(\d{1,2})?.*/

  # Start time of the action, parsed from the time string
  def parse_start_time
    return nil unless date
    day = date
    return nil unless time
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[1], min: matches[2], year: day.year, month: day.month, day: day.day) if matches
  end

  # End time of the action, parsed from the time string
  def parse_end_time
    return nil unless date
    day = date
    return nil unless time
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[3], min: matches[4], year: day.year, month: day.month, day: day.day) if matches && matches[3]
  end
end
