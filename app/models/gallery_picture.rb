class GalleryPicture < ApplicationRecord

  mount_uploader :picture, GalleryPictureUploader
  belongs_to :gallery
  belongs_to :uploader, class_name: 'User'

  scope :visible, -> { where(visible: true) }
  scope :invisible,  -> { where(visible: false) }
  scope :visible_for_user, ->(user) { user ? where("visible = 't' or uploader_id = #{user.id}") : visible }

  def make_visible!
    update_attribute :visible, true
  end

  def make_invisible!
    update_attribute :visible, false
  end

  def rotate(direction)
    picture.manipulate! do |img|
      img.rotate(90 * direction)
    end
    picture.store!
    picture.recreate_versions!
  end

end
