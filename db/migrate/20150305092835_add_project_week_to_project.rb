class AddProjectWeekToProject < ActiveRecord::Migration
  def change
    add_column :projects, :project_week_id, :integer
  end
end
