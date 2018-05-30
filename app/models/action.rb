class Action < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, ActionPictureUploader

  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user
  has_many :events, -> { order 'date ASC' }, foreign_key: :initiative_id, dependent: :destroy # TODO: order by date + time
  accepts_nested_attributes_for :events, allow_destroy: true
  belongs_to :action_group
  has_many :subactions, class_name: 'Action', foreign_key: :parent_action_id
  belongs_to :parent_action, class_name: 'Action', foreign_key: :parent_action_id, optional: true

  validates_presence_of :title
  validate :parent_action_cannot_be_same_action, :parent_action_cannot_be_a_subaction

  scope :visible,  -> { where(actions: { visible: true }) }
  scope :hidden,   -> { where(actions: { visible: false }) }
  scope :toplevel, -> { where(actions: { parent_action_id: nil }) }
  scope :upcoming, -> { joins(:events).where('events.date >= ?', Date.current).distinct }
  scope :finished, -> { joins(:events).where('events.date < ?', Date.current).distinct }

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
    User.joins(:events_as_volunteer).where(events: {initiative_id: id})
  end

  def volunteers_in_subactions
    User.joins(events_as_volunteer: :initiative).where(actions: {parent_action_id: id, visible: true})
  end

  def leaders_in_subactions
    User.joins(:actions_as_leader).where(actions: {parent_action_id: id, visible: true})
  end

  def volunteer?(user)
    user.present? && user.events_as_volunteer.where(initiative_id: id).any?
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

  def available_places
    events.sum(&:available_places)
  end

  def desired_team_size
    events.sum(:desired_team_size)
  end

  def team_size
    events.sum(:team_size)
  end

  def total_available_places
    all_events.sum(&:available_places)
  end

  def total_team_size
    all_events.sum(:team_size)
  end

  def total_desired_team_size
    all_events.sum(:desired_team_size)
  end

  def all_dates
    all_events.pluck(:date).compact.uniq.sort
  end

  def all_events
    Event.joins(:initiative).where('initiative_id = ? OR (actions.parent_action_id = ? AND actions.visible)', id, id)
  end

  def finished?
    all_events.upcoming.empty?
  end

  def subaction?
    parent_action != nil
  end

  def full_title
    subaction? ? parent_action.title + ' – ' + title : title
  end

  def status
    if finished?
      :finished
    elsif total_available_places.zero?
      :full
    else
      total_available_places < 3 ? :soon_full : :empty
    end
  end

  def clone
    action_copy = dup
    action_copy.title = I18n.t('general.label.copyOf', title: title)
    action_copy.action_group = ActionGroup.all.order(start_date: :desc).first
    action_copy.parent_action = nil
    action_copy.gallery = Gallery.create!
    action_copy.save!
    action_copy.picture = picture.dup
    action_copy.picture.store!
    action_copy
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

end
