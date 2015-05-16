class CreateGalleryPictures < ActiveRecord::Migration
  def change
    create_table :gallery_pictures do |t|
      t.integer :gallery_id
      t.string :picture

      t.timestamps
    end
  end
end
