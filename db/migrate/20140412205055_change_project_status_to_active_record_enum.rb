class ChangeProjectStatusToActiveRecordEnum < ActiveRecord::Migration
  def change
    drop_table :project_statuses
    rename_column :projects, :status_id, :status
    change_column :projects, :status, :integer, default: 1
  end
end
