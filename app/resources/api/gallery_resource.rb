class Api::GalleryResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attribute :title

  has_many :actions
  has_many :gallery_pictures

end
