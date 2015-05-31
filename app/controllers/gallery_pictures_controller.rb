class GalleryPicturesController < ApplicationController
  before_action :set_gallery_picture, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  respond_to :html

  def index
    @gallery_pictures = GalleryPicture.all
    respond_with(@gallery_pictures)
  end

  def show
    respond_with(@gallery_picture)
  end

  def new
    @gallery_picture = GalleryPicture.new
    respond_with(@gallery_picture)
  end

  def edit
  end

  def create
    @gallery_picture = GalleryPicture.new(gallery_picture_params)
    @gallery_picture.save
    respond_with(@gallery_picture)
  end

  def update
    @gallery_picture.update(gallery_picture_params)
    #respond_with(@gallery_picture)
    redirect_to @gallery_picture.gallery
  end

  def destroy
    @gallery_picture.destroy
    redirect_to request.referer
  end

  private
    def set_gallery_picture
      @gallery_picture = GalleryPicture.find(params[:id])
    end

    def gallery_picture_params
      params.require(:gallery_picture).permit(:gallery_id, :picture)
    end
end
