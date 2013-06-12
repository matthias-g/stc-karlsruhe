class CreateProjectsLeadersJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_leaders, :id => false do |t|
      t.integer :project_id
      t.integer :user_id
    end
  end
end
