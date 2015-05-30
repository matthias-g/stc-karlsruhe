class GalleriesController < ApplicationController
  before_action :set_gallery, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
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
    @gallery.gallery_pictures.build
    respond_with(@gallery)
  end

  def edit
  end

  def create
    @gallery = Gallery.new(gallery_params)
    if @gallery.save && params[:gallery_pictures]
      params[:gallery_pictures][:picture].each do |picture|
        @gallery.gallery_pictures.create!(picture: picture, gallery: @gallery, uploader: current_user)
      end
    end
    respond_with(@gallery)
  end

  def update
    if @gallery.update(gallery_params) && params[:gallery_pictures]
      params[:gallery_pictures][:picture].each do |picture|
        @gallery.gallery_pictures.create!(picture: picture, gallery: @gallery, uploader: current_user)
      end
    end
    return redirect_to request.referer if request.referer
    respond_with(@gallery)
  end

  def destroy
    @gallery.destroy
    respond_with(@gallery)
  end

  private
    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    def gallery_params
      params.require(:gallery).permit(:title, gallery_pictures_attributes: [:id, :gallery_id, :picture])
    end
end
