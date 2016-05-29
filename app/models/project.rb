class Project < ActiveRecord::Base

  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_and_belongs_to_many :days, class_name: 'ProjectDay'
  belongs_to :project_week
  has_many :subprojects, class_name: 'Project', foreign_key: :parent_project_id
  belongs_to :parent_project, class_name: 'Project', foreign_key: :parent_project_id
  belongs_to :gallery, dependent: :destroy

  validates_presence_of :title, :desired_team_size
  validates :desired_team_size, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  before_create :create_gallery!

  scope :toplevel, -> { where(parent_project: nil) }
  scope :visible,  -> { where.not(status: Project.statuses[:hidden]) }

  enum status: { active: 1, finished: 2, hidden: 3 }

  mount_uploader :picture, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged



  def volunteers
    users.only_volunteers
  end

  def leaders
    users.only_leaders
  end

  def volunteers_in_subprojects
    User.joins(:projects).where("parent_project_id = #{self.id}").only_volunteers
  end

  def aggregated_users
    return users if subprojects.empty?
    User.joins(:projects).where("(projects.id = #{self.id} or parent_project_id = #{self.id})")
  end

  def aggregated_volunteers
    aggregated_users.only_volunteers
  end

  def aggregated_leaders
    aggregated_users.only_leaders
  end

  def aggregated_desired_team_size
    size = self.desired_team_size
    subprojects.each { |p| size += p.desired_team_size unless p.hidden? }
    size
  end



  def has_leader? (user)
    leaders.include? user
  end

  def has_volunteer? (user)
    volunteers.include? user
  end

  def has_volunteer_in_subproject? (user)
    volunteers_in_subprojects.include? user
  end

  def add_volunteer (user)
    (!has_volunteer? user) && participations.build(user: user, as_leader: false).save
  end

  def add_leader (user)
    (!has_leader? user) && participations.build(user: user, as_leader: false).save
  end

  def remove_volunteer (user)
    p = participations.where(user: user, as_leader: false).first
    p.present? && p.destroy!
  end

  def remove_leader (user)
    p = participations.where(user: user, as_leader: true).first
    p.present? && p.destroy!
  end



  def activate!
    active!
    #subprojects.each {|p| p.active!}
  end

  def hide!
    hidden!
    subprojects.each {|p| p.hidden!}
  end

  def close!
    finished!
    subprojects.each {|p| p.finished!}
  end



  def crop_picture(x,y,w,h,version)
    self.crop_x = x
    self.crop_y = y
    self.crop_w = w
    self.crop_h = h
    picture.recreate_versions!(version)
  end


  def has_free_places?
    desired_team_size > volunteers.count
  end

  def is_subproject?
    parent_project.present?
  end

  def show_picture?
    picture_source.present? && picture && picture.file
  end

  def dynamic_status
    return status unless active?
    total = aggregated_desired_team_size
    free = total - aggregated_volunteers.count
    percent = 100 * free.to_f / total
    if (free == 0)
      :full
    elsif (percent < 20) or (free < 2)
      :soon_full
    else
      :open
    end
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

  def create_gallery!
    self.gallery = Gallery.create!
  end

end
