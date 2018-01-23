class GalleriesController < ApplicationController
  before_action :set_gallery, except: [:index, :new, :create]
  before_action :authorize_gallery, except: [:index, :new, :create]
  after_action :verify_authorized

  respond_to :html

  def index
    authorize Gallery.new
    @galleries = Gallery.all
    respond_with(@galleries)
  end

  def show
    @gallery_pictures = @gallery.gallery_pictures
    if @gallery_pictures.count == 0
      @gallery.gallery_pictures.build
    end
    respond_with(@gallery)
  end

  def new
    @gallery = Gallery.new
    authorize @gallery
    @gallery.gallery_pictures.build
    respond_with(@gallery)
  end

  def edit
  end

  def create
    @gallery = Gallery.new(gallery_params)
    authorize @gallery
    upload_pictures if @gallery.save
    respond_with(@gallery)
  end

  def update
    upload_pictures if @gallery.update(gallery_params)
    return redirect_to request.referer if request.referer
    respond_with(@gallery)
  end

  def destroy
    @gallery.destroy
    respond_with(@gallery)
  end

  def make_all_visible
    GalleryPicture.where(gallery_id: @gallery.id).update_all(visible: true)
    return redirect_to request.referer if request.referer
    redirect_to @gallery
  end

  def make_all_invisible
    GalleryPicture.where(gallery_id: @gallery.id).update_all(visible: false)
    return redirect_to request.referer if request.referer
    redirect_to @gallery
  end


  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

  def gallery_params
    params.require(:gallery).permit(:title, gallery_pictures_attributes: [:id, :gallery_id, :picture])
  end

  def upload_pictures
    if params[:gallery_pictures] && params[:gallery_pictures][:picture].size > 0
      params[:gallery_pictures][:picture].each do |picture|
        @gallery.gallery_pictures.create!(picture: picture, gallery: @gallery, uploader: current_user, visible: false)
      end
      flash[:notice] = t('action.message.galleryPicturesUploaded')
      send_notice_mail
    end
  end

  def send_notice_mail
    picture_count = params[:gallery_pictures][:picture].size
    Mailer.gallery_picture_uploaded_notification(@gallery, picture_count, current_user).deliver_now
  end

  def authorize_gallery
    authorize @gallery
  end
end
