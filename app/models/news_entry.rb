class NewsEntry < ApplicationRecord

  include PhotoGallery
  include CroppablePicture
  mount_uploader :picture, NewsEntryImageUploader

  validates_presence_of :title, :text, :category

  scope :visible,  -> { where(visible: true) }

  enum category: {general: 1, partners: 2, actions: 3, media: 4, insight: 5 }

  extend FriendlyId
  friendly_id :friendly_id_candidates, use: :slugged

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def friendly_id_candidates
    [:title]
  end

end
