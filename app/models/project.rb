class Project < ActiveRecord::Base

  has_many :users, through: :participations
  has_many :participations
  has_and_belongs_to_many :days, :class_name => 'ProjectDay'

  before_save :adjust_status
  validates_presence_of :desired_team_size

  scope :active, -> { where.not(status: 'closed') }

  enum status: { open: 1, soon_full: 2, full: 3, closed: 4 }

  mount_uploader :picture, ImageUploader

  def volunteers
    users.where(participations: {as_leader: false})
  end

  def add_volunteer user
    users << user
  end

  def has_volunteer? user
    volunteers.include? user
  end

  def delete_volunteer user
    volunteers.delete user
  end

  def leaders
    users.where(participations: {as_leader: true})
  end

  def add_leader user
    Participation.create(project: self, user: user, as_leader: true)
  end

  def has_leader? user
    leaders.include? user
  end

  def delete_leader(user)
    leaders.delete(user)
  end

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  def adjust_status
    free = desired_team_size - volunteers.count
    if free > 5
      self.status = :open
    elsif free > 0
      self.status = :soon_full
    else
      self.status = :full
    end
  end

end
