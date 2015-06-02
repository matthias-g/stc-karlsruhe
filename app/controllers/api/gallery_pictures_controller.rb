class Api::GalleryPicturesController < ApplicationController

  before_action :set_gallery_picture, only: [:destroy]
  before_action :authenticate_admin_user_or_uploader!

  respond_to :json

  def destroy
    @gallery_picture.destroy
    respond_with(@gallery_picture)
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
