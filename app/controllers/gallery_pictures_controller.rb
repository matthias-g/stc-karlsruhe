class GalleryPicturesController < ApplicationController
  before_action :set_gallery_picture, except: [:index, :new, :create]
  before_action :authenticate_admin!, only: [:index, :new, :create]
  before_action :authorize_gallery_picture, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @gallery_pictures = policy_scope(GalleryPicture)
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
    @gallery_picture.uploader = current_user
    authorize_gallery_picture
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
    return redirect_to request.referer if request.referer
    redirect_to @gallery_picture.gallery
  end

  def make_visible
    @gallery_picture.make_visible!
    return redirect_to request.referer if request.referer
    redirect_to @gallery_picture.gallery
  end

  def make_invisible
    @gallery_picture.make_invisible!
    return redirect_to request.referer if request.referer
    redirect_to @gallery_picture.gallery
  end

  private

  def set_gallery_picture
    @gallery_picture = GalleryPicture.find(params[:id])
  end

  def gallery_picture_params
    params.require(:gallery_picture).permit(:gallery_id, :picture)
  end

  def authorize_gallery_picture
    authorize @gallery_picture
  end

end
