class CreateProjectsVolunteerTypesJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_projects_volunteer_types, :id => false do |t|
      t.integer :project_id
      t.integer :volunteer_type_id
    end
  end
end
