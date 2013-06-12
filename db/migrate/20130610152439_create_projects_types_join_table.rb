class CreateProjectsTypesJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_projects_types, :id => false do |t|
      t.integer :project_id
      t.integer :type_id
    end
  end
end
