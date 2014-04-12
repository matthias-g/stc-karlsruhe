class CreateJoinTableProjectsProjectDays < ActiveRecord::Migration
  def change
    create_join_table :projects, :project_days do |t|
      t.index [:project_id, :project_day_id]
      t.index [:project_day_id, :project_id]
    end
  end
end
