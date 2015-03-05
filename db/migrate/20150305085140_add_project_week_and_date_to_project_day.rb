class AddProjectWeekAndDateToProjectDay < ActiveRecord::Migration
  def change
    add_column :project_days, :project_week_id, :integer
    add_column :project_days, :date, :date
  end
end
