class GalleryPicture < ActiveRecord::Base

  mount_uploader :picture, GalleryPictureUploader
  belongs_to :gallery
  belongs_to :uploader, class_name: 'User'

end
