class CreateProjectsLocationsJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_projects_locations, :id => false do |t|
      t.integer :project_id
      t.integer :location_id
    end
  end
end
