class CreateRefineryProjectsLocations < ActiveRecord::Migration
  def change
    create_table :refinery_projects_locations do |t|
      t.string :title

      t.timestamps
    end
  end
end
