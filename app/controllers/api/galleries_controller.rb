class Api::GalleriesController < ApplicationController
  before_action :set_gallery

  respond_to :json

  def show
    @gallery_pictures = @gallery.gallery_pictures.to_json(only: [:width, :height, :picture])
    respond_with(@gallery)
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

end
