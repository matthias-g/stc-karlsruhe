class Initiative < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, ActionPictureUploader

  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user
  has_many :events, -> { order 'date ASC' }, foreign_key: :initiative_id, dependent: :destroy # TODO: order by date + time
  accepts_nested_attributes_for :events, allow_destroy: true

  validates_presence_of :title
  validates_presence_of :type

  scope :visible,  -> { where(initiatives: { visible: true }) }
  scope :hidden,   -> { where(initiatives: { visible: false }) }
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

  def volunteer?(user)
    user.present? && user.events_as_volunteer.where(initiative_id: id).any?
  end

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
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
    Event.joins(:initiative).where('initiative_id = ?', id)
  end

  def finished?
    all_events.upcoming.empty?
  end

  def full_title
    title
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

end
