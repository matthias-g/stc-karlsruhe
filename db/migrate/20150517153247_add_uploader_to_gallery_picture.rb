class AddUploaderToGalleryPicture < ActiveRecord::Migration
  def change
    add_column :gallery_pictures, :uploader_id, :integer
  end
end
