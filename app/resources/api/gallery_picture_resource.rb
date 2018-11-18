class Api::GalleryPictureResource < JSONAPI::Resource
  include JSONAPI::Authorization::PunditScopedResource

  attributes :visible, :width, :height, :desktop_width, :desktop_height
  attribute :picture
  attribute :editable

  has_one :gallery
  has_one :uploader, class_name: 'User'

  def editable
    current_user = context[:user]
    return false unless current_user
    current_user.eql?(uploader) || current_user.admin?
  end

  def fetchable_fields
    Pundit.policy(context[:user], @model_class).permitted_attributes_for_show
  end

end
