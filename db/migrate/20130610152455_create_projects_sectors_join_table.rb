class CreateProjectsSectorsJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_projects_sectors, :id => false do |t|
      t.integer :project_id
      t.integer :sector_id
    end
  end
end
