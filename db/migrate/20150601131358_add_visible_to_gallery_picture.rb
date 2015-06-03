class AddVisibleToGalleryPicture < ActiveRecord::Migration
  def change
    add_column :gallery_pictures, :visible, :boolean, default: false
    add_index :gallery_pictures, :visible
  end
end
