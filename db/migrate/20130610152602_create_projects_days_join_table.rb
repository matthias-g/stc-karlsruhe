class CreateProjectsDaysJoinTable < ActiveRecord::Migration
  def change
    create_table :refinery_projects_projects_days, :id => false do |t|
      t.integer :project_id
      t.integer :day_id
    end
  end
end
