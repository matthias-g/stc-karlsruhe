class AddGalleryToNewsEntry < ActiveRecord::Migration
  def change
    add_column :news_entries, :gallery_id, :integer
    add_index :news_entries, :gallery_id

    reversible do |change|
      change.up do
        NewsEntry.all.each{ |news_entry| news_entry.gallery = Gallery.create!; news_entry.save! }
      end

      change.down do
        NewsEntry.all.each{ |news_entry| news_entry.gallery.destroy! if news_entry.gallery }
      end
    end
  end
end
