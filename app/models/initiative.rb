class Initiative < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, InitiativePictureUploader

  has_and_belongs_to_many :tags
  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user,
            after_add: :update_cache_fields, after_remove: :update_cache_fields
  has_many :events, -> { order 'date ASC, start_time ASC' }, foreign_key: :initiative_id, dependent: :destroy,
            after_add: :update_cache_fields, after_remove: :update_cache_fields
  accepts_nested_attributes_for :events, allow_destroy: true

  validates_presence_of :title
  validates_presence_of :type
  after_save :update_cache_fields

  scope :visible,  -> { where(initiatives: { visible: true }) }
  scope :hidden,   -> { where(initiatives: { visible: false }) }
  scope :upcoming, -> { joins(:events).where('events.date >= ?', Date.current).distinct }
  scope :finished, -> { joins(:events).where('events.date < ?', Date.current).distinct }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def is_action?
    type == 'Action'
  end

  def contact_leaders(message, sender)
    (leaders + [current_user]).uniq.each do |recipient|
      Mailer.contact_leaders_mail(message.body, message.subject, sender, recipient, self).deliver_later
    end
  end

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

  def full_title
    title
  end

  def finished?
    events.upcoming.empty?
  end

  def date
    nil
  end

  def update_cache_fields(*args)
  end

  protected

  def slug_candidates
    candidates = []
    candidates << [full_title]
    candidates
  end

  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end
