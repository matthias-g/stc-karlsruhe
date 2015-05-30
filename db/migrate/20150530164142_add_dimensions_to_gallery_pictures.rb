class AddDimensionsToGalleryPictures < ActiveRecord::Migration
  def change
    add_column :gallery_pictures, :width, :integer
    add_column :gallery_pictures, :height, :integer
  end
end
