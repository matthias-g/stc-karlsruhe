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
  before_save :adjust_status
  after_save :adjust_parent_status

  scope :visible,  -> { where(actions: {visible: true}) }
  scope :toplevel, -> { where(parent_action_id: nil) }
  scope :active,   -> { visible.where('status <> ?', Action.statuses[:closed]) }

  enum status: { open: 1, soon_full: 2, full: 3, closed: 4 }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged


  def volunteers_in_subactions
    User.joins(:actions_as_volunteer).where("parent_action_id = #{self.id}")
  end

  def aggregated_volunteers
    User.joins(:actions_as_volunteer).where("(actions.id = #{self.id || 'NULL'} or parent_action_id = #{self.id || 'NULL'})")
  end

  def aggregated_leaders
    User.joins(:actions_as_leader).where("(actions.id = #{self.id || 'NULL'} or parent_action_id = #{self.id || 'NULL'})")
  end

  def aggregated_desired_team_size
    desired_team_size = self.desired_team_size
    subactions.each { |p| desired_team_size += p.visible? ? p.desired_team_size : 0 }
    desired_team_size
  end


  def add_volunteer user
    volunteers << user
    self.save #adjusts status
  end

  def has_volunteer? user
    volunteers.include? user
  end

  def has_volunteer_in_subaction? user
    volunteers_in_subactions.include? user
  end

  def delete_volunteer user
    volunteers.destroy user
    self.save #adjusts status
  end

  def add_leader user
    leaders << user
  end

  def has_leader? user
    leaders.include? user
  end

  def delete_leader user
    leaders.destroy user
  end


  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  def close!
    self.status = :closed
    subactions.each {|p| p.close!}
    save
  end

  def open!
    self.status = :open
    subactions.each {|p| p.open!}
    save
  end


  def dates
    if subactions.count > 0
      dates = subactions.collect{ |p| p.date }
    else
      dates = [date]
    end
    dates.reject{ |p| p == nil}
  end



  def has_free_places?
    desired_team_size - volunteers.count > 0
  end

  def is_subaction?
    parent_action != nil
  end

  TIME_REGEX = /(\d{1,2})[:\.-]?(\d{1,2})?[^\d\/]*(\d{1,2})?[:\.-]?(\d{1,2})?.*/

  def start_time
    return nil unless date
    day = date
    return nil unless day
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[1], min: matches[2], year: day.year, month: day.month, day: day.day) if matches
  end

  def end_time
    return nil unless date
    day = date
    return nil unless day
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[3], min: matches[4], year: day.year, month: day.month, day: day.day) if matches && matches[3]
  end



  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def slug_candidates
    candidates = []
    candidates << :title
    candidates << [:title, action_group.title] if action_group
    candidates
  end

  def available_slots_count
    desired_team_size = self.desired_team_size
    volunteer_count = self.volunteers.count
    subactions.active.each do |action|
      desired_team_size += action.desired_team_size
      volunteer_count += action.volunteers.count
    end
    desired_team_size - volunteer_count
  end

  def adjust_status
    if self.status == 'closed'
      return
    end
    free = available_slots_count
    if free > 2
      self.status = :open
    elsif free > 0
      self.status = :soon_full
    else
      self.status = :full
    end
  end

  def adjust_parent_status
    parent_action.save if parent_action # adjusts status
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
    return if status == 'closed'
    Mailer.action_participate_volunteer_notification(user, self).deliver_now if user.receive_notifications_for_new_participation
    Mailer.action_participate_leader_notification(user, self).deliver_now
  end

  def on_volunteer_removed(user)
    return if status == 'closed'
    Mailer.leaving_action_notification(user, self).deliver_now
  end

end
