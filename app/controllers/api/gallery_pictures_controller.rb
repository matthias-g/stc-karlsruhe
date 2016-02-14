class Api::GalleryPicturesController < Api::ApiController

  before_action :set_gallery_picture, only: [:destroy, :rotateRight, :rotateLeft]
  before_action :authenticate_admin_user_or_uploader!

  def destroy
    @gallery_picture.destroy
    respond_with(@gallery_picture)
  end

  def rotateRight
    @gallery_picture.rotate(1)
    respond_with(@gallery_picture) # todo what view makes sense?
  end

  def rotateLeft
    @gallery_picture.rotate(-1)
    respond_with(@gallery_picture) # todo what view makes sense?
  end

  private

  def set_gallery_picture
    @gallery_picture = GalleryPicture.find(params[:id])
  end

  def authenticate_admin_user_or_uploader!
    not_authorized unless current_user
    unless @gallery_picture.uploader.id == current_user.id
      authenticate_admin_user!
    end
  end
end
