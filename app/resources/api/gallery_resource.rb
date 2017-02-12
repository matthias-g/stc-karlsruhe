class Api::GalleryResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attribute :title

  has_many :projects
  has_many :gallery_pictures

end
