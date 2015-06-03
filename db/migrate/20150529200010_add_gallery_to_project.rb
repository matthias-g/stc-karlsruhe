class AddGalleryToProject < ActiveRecord::Migration
  def change
    add_column :projects, :gallery_id, :integer
    add_index :projects, :gallery_id

    reversible do |change|
      change.up do
        Project.all.each{ |project| project.create_gallery!; project.save! }
      end

      change.down do
        Project.all.each{ |project| project.gallery.destroy! if project.gallery }
      end
    end

  end
end
