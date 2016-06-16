class NewsEntry < ActiveRecord::Base

  belongs_to :gallery, dependent: :destroy

  validates_presence_of :title, :text, :category
  before_create :create_gallery!

  scope :visible,  -> { where(visible: true) }

  enum category: { general: 1, partners: 2, projects: 3, media: 4, insight: 5 }

  mount_uploader :picture, NewsEntryImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  extend FriendlyId
  friendly_id :friendly_id_candidates, use: :slugged

  def show_picture?
    picture_source && !picture_source.empty? && picture && picture.file
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

  def friendly_id_candidates
    [:title]
  end

  private

  def create_gallery!
    self.gallery = Gallery.create!
  end

end
