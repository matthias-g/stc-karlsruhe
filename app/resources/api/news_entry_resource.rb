class Api::NewsEntryResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :title, :text, :teaser, :category, :visible
  attribute :picture

end
