class Event < ApplicationRecord

  belongs_to :initiative, class_name: 'Action'

  has_many :participations, dependent: :destroy
  has_many :volunteers, class_name: 'User', through: :participations, source: :user,
           after_add: :on_volunteer_added, after_remove: :on_volunteer_removed

  # TODO
  # validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  scope :upcoming, -> { where('date >= ?', Date.today) }
  scope :finished, -> { where('date < ?', Date.today) }

  # TODO
  #validates_presence_of :desired_team_size

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
    if date && date >= Date.today
      desired_team_size - team_size.to_i
    else
      0
    end
  end

  def finished?
    return true unless date
    date < Date.today
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


  private

  def on_volunteer_added(user)
    return if initiative.finished?
    Mailer.action_participate_volunteer_notification(user, initiative).deliver_now if user.receive_notifications_for_new_participation
    Mailer.action_participate_leader_notification(user, initiative).deliver_now
  end

  def on_volunteer_removed(user)
    return if initiative.finished?
    Mailer.leaving_action_notification(user, initiative).deliver_now
  end

end
