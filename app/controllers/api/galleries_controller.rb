class Api::GalleriesController < ApplicationController
  before_action :set_gallery

  respond_to :json

  def show
    gallery_pictures = @gallery.gallery_pictures.visible_for_user(current_user).as_json(only: [:width, :height, :picture, :id])
    if current_user
      user_is_admin = current_user.is_admin?
      @gallery.gallery_pictures.visible_for_user(current_user).each_with_index { |picture, index|
        if picture.uploader_id == current_user.id || user_is_admin
          gallery_pictures[index][:editable] = true
        end
      }
    end
    @gallery_pictures = gallery_pictures.to_json
    respond_with(@gallery)
  end

  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

end
