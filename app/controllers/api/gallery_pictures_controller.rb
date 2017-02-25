class Api::GalleryPicturesController < Api::ApiController

  include JSONAPI::ActsAsResourceController

  before_action :set_gallery_picture, only: [:rotateRight, :rotateLeft]

  def rotateRight
    authorize @gallery_picture, :update?
    @gallery_picture.rotate(1)
    respond_with(@gallery_picture) # todo what view makes sense?
  end

  def rotateLeft
    authorize @gallery_picture, :update?
    @gallery_picture.rotate(-1)
    respond_with(@gallery_picture) # todo what view makes sense?
  end


  private

  def context
    { user: current_user }
  end

  def set_gallery_picture
    @gallery_picture = GalleryPicture.find(params[:id])
  end

end
