class Api::GalleryPictureResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :visible, :width, :height, :desktop_width, :desktop_height
  attribute :picture

  has_one :gallery
  has_one :uploader, class_name: 'User'
end
