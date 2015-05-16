class GalleryPicture < ActiveRecord::Base

  mount_uploader :picture, GalleryPictureUploader
  belongs_to :gallery, dependent: :destroy

end
