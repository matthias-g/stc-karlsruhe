class CreateRefineryProjectsTypes < ActiveRecord::Migration
  def change
    create_table :refinery_projects_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
