class CreateProjectsProjects < ActiveRecord::Migration

  def up
    create_table :refinery_projects do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.integer :image_id
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-projects"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/projects/projects"})
    end

    drop_table :refinery_projects

  end

end
