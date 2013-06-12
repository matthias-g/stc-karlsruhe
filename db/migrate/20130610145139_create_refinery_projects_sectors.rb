class CreateRefineryProjectsSectors < ActiveRecord::Migration
  def change
    create_table :refinery_projects_sectors do |t|
      t.string :title

      t.timestamps
    end
  end
end
