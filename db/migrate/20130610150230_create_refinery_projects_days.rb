class CreateRefineryProjectsDays < ActiveRecord::Migration
  def change
    create_table :refinery_projects_days do |t|
      t.string :title

      t.timestamps
    end
  end
end
