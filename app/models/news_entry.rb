class NewsEntry < ActiveRecord::Base
  enum category: { general: 1, partners: 2, projects: 3, media: 4, insight: 5 }

  validates_presence_of :title, :text, :category

  mount_uploader :picture, NewsEntryImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #after_update :crop_picture

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

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
    [:title]
  end
end
