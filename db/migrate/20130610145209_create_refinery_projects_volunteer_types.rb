class CreateRefineryProjectsVolunteerTypes < ActiveRecord::Migration
  def change
    create_table :refinery_projects_volunteer_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
