class Event < ApplicationRecord

  belongs_to :initiative, class_name: 'Action'

  has_many :participations, dependent: :destroy, counter_cache: :team_size
  has_many :volunteers, class_name: 'User', through: :participations, source: :user,
           after_add: :on_volunteer_added, after_remove: :on_volunteer_removed

  validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  scope :upcoming, -> { where('date >= ?', Date.current).order(date: :asc) }
  scope :finished, -> { where('date < ?', Date.current).order(date: :desc) }
  scope :recent,   -> { where('date > ?', 1.year.ago).order(date: :desc) }

  validates_presence_of :desired_team_size

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
    if date && date >= Date.current && desired_team_size
      desired_team_size - team_size
    else
      0
    end
  end

  def finished?
    return true unless date
    date < Date.current
  end

  def status
    if finished?
      :finished
    elsif available_places.zero?
      :full
    else
      available_places < 3 ? :soon_full : :empty
    end
  end

  TIME_REGEX = /(\d{1,2})[:\.]?(\d{1,2})?[^\d\/]*(\d{1,2})?[:\.-]?(\d{1,2})?.*/

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


  private

  def on_volunteer_added(user)
    return if finished?
    if user.receive_notifications_for_new_participation
      Mailer.event_join_reminder(user, self).deliver_now
    end
    recipients = initiative.leaders.where(receive_notifications_about_volunteers: true)
    return if recipients.blank?
    recipients.uniq.each do |recipient|
      Mailer.event_join_notification(recipient, user, self).deliver_now
    end
  end

  def on_volunteer_removed(user)
    return if finished?
    recipients = initiative.leaders.where(receive_notifications_about_volunteers: true)
    recipients.uniq.each do |recipient|
      Mailer.event_leave_notification(recipient, user, self).deliver_now
    end
  end

end
