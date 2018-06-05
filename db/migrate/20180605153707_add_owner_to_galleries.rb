class AddOwnerToGalleries < ActiveRecord::Migration[5.2]

  def change
    add_reference :galleries, :owner, polymorphic: true, index: true

    Initiative.where('gallery_id IS NOT NULL').all.each do |initiative|
      gallery = Gallery.find(initiative.gallery_id)
      gallery.owner = initiative
      gallery.save!
    end

    NewsEntry.where('gallery_id IS NOT NULL').all.each do |news_entry|
      gallery = Gallery.find(news_entry.gallery_id)
      gallery.owner = news_entry
      gallery.save!
    end

    remove_column :initiatives, :gallery_id, :integer
    remove_column :news_entries, :gallery_id, :integer
  end
end