class Project < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, ImageUploader

  has_many :participations, dependent: :destroy
  has_many :volunteers, class_name: 'User', through: :participations, source: :user
  has_many :leaderships, dependent: :destroy
  has_many :leaders, class_name: 'User', through: :leaderships, source: :user
  has_and_belongs_to_many :days, class_name: 'ProjectDay'
  belongs_to :project_week
  has_many :subprojects, class_name: 'Project', foreign_key: :parent_project_id
  belongs_to :parent_project, class_name: 'Project', foreign_key: :parent_project_id

  validates_presence_of :title, :desired_team_size
  validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validate :parent_project_cannot_be_same_project, :parent_project_cannot_be_a_subproject
  before_save :adjust_status
  after_save :adjust_parent_status

  scope :visible,  -> { where(projects: {visible: true}) }
  scope :toplevel, -> { where(parent_project_id: nil) }
  scope :active,   -> { visible.where('status <> ?', Project.statuses[:closed]) }

  enum status: { open: 1, soon_full: 2, full: 3, closed: 4 }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged


  def volunteers_in_subprojects
    User.joins(:projects_as_volunteer).where("parent_project_id = #{self.id}")
  end

  def aggregated_volunteers
    User.joins(:projects_as_volunteer).where("(projects.id = #{self.id || 'NULL'} or parent_project_id = #{self.id || 'NULL'})")
  end

  def aggregated_leaders
    User.joins(:projects_as_leader).where("(projects.id = #{self.id || 'NULL'} or parent_project_id = #{self.id || 'NULL'})")
  end

  def aggregated_desired_team_size
    desired_team_size = self.desired_team_size
    subprojects.each { |p| desired_team_size += p.visible? ? p.desired_team_size : 0 }
    desired_team_size
  end


  def add_volunteer user
    volunteers << user
    self.save #adjusts status
  end

  def has_volunteer? user
    volunteers.include? user
  end

  def has_volunteer_in_subproject? user
    volunteers_in_subprojects.include? user
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
    subprojects.each {|p| p.close!}
    save
  end

  def open!
    self.status = :open
    subprojects.each {|p| p.open!}
    save
  end



  def has_free_places?
    desired_team_size - volunteers.count > 0
  end

  def is_subproject?
    parent_project != nil
  end

  TIME_REGEX = /(\d{1,2})[:\.-]?(\d{1,2})?[^\d\/]*(\d{1,2})?[:\.-]?(\d{1,2})?.*/

  def start_time
    return nil unless days.first
    day = days.first.date
    return nil unless day
    matches = time.match(TIME_REGEX)
    Time.now.change(hour: matches[1], min: matches[2], year: day.year, month: day.month, day: day.day) if matches
  end

  def end_time
    return nil unless days.first
    day = days.first.date
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
    candidates << [:title, project_week.title] if project_week
    candidates
  end

  def adjust_status
    if self.status == 'closed'
      return
    end
    free = aggregated_desired_team_size - aggregated_volunteers.count
    if free > 2
      self.status = :open
    elsif free > 0
      self.status = :soon_full
    else
      self.status = :full
    end
  end

  def adjust_parent_status
    parent_project.save if parent_project # adjusts status
  end

  def parent_project_cannot_be_same_project
    if parent_project == self
      errors.add(:parent_project, "can't be same project")
    end
  end

  def parent_project_cannot_be_a_subproject
    if parent_project&.parent_project
      errors.add(:parent_project, "can't be a subproject itself")
    end
  end

end
