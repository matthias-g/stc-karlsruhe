class AddDesktopDimensionsToGalleryPictures < ActiveRecord::Migration
  def change
    add_column :gallery_pictures, :desktop_width, :integer
    add_column :gallery_pictures, :desktop_height, :integer
  end
end
