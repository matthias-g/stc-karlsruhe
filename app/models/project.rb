class Project < ActiveRecord::Base

  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_and_belongs_to_many :days, class_name: 'ProjectDay'
  belongs_to :project_week
  has_many :subprojects, class_name: 'Project', foreign_key: :parent_project_id
  belongs_to :parent_project, class_name: 'Project', foreign_key: :parent_project_id
  belongs_to :gallery, dependent: :destroy

  validates_presence_of :title, :desired_team_size
  validate :desired_team_size, numericality: {only_integer: true, greater_than: 0}
  before_save :adjust_status
  after_save :adjust_parent_status
  before_create :create_gallery!

  scope :visible, -> { where(projects: {visible: true}) }
  scope :toplevel, -> { where(parent_project_id: nil) }

  enum status: { open: 1, soon_full: 2, full: 3, closed: 4 }

  mount_uploader :picture, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #after_update :crop_picture

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def volunteers
    users.where(participations: {as_leader: false})
  end

  def aggregated_volunteers
    if !subprojects || subprojects.count == 0
      return volunteers
    end
    User.joins(:projects).where("(participations.project_id = #{self.id} or parent_project_id = #{self.id}) and participations.as_leader = false")
  end

  def aggregated_leaders
    if !subprojects || subprojects.count == 0
      return leaders
    end
    User.joins(:projects).where("(participations.project_id = #{self.id} or parent_project_id = #{self.id}) and participations.as_leader = true")
  end

  def volunteers_in_subprojects
    User.joins(:projects).where('projects.parent_project_id' => self.id).where('participations.as_leader' => false)
  end

  def add_volunteer user
    users << user
    self.save #adjusts status
  end

  def has_volunteer? user
    volunteers.include? user
  end

  def has_volunteer_in_subproject? user
    volunteers_in_subprojects.include? user
  end

  def delete_volunteer user
    Participation.where(project_id: self.id, user_id: user.id, as_leader: false).first.destroy!
    self.save #adjusts status
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
    Participation.where(project_id: self.id, user_id: user.id, as_leader: true).first.destroy!
  end

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  def close!
    self.status = :closed
    self.save
  end

  def open!
    self.status = :open
    self.save
  end

  def closed?
    self.status == 'closed'
  end

  def has_free_places?
    desired_team_size - volunteers.count > 0
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

  def aggregated_desired_team_size
    desired_team_size = self.desired_team_size
    if subprojects
      subprojects.each { |p| desired_team_size += p.desired_team_size }
    end
    desired_team_size
  end

  def is_subproject?
    parent_project != nil
  end

  def show_picture?
    picture_source && !picture_source.empty? && picture
  end

  def crop_picture(x,y,w,h,version)
    self.crop_x = x
    self.crop_y = y
    self.crop_w = w
    self.crop_h = h
    picture.recreate_versions!(version)
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    candidates = []
    candidates << :title
    candidates << [:title, project_week.title] if project_week
    candidates
  end

  def create_gallery!
    self.gallery = Gallery.create!
  end

end
