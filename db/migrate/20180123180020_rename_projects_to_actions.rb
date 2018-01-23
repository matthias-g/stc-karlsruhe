class RenameProjectsToActions < ActiveRecord::Migration[5.1]
  def change
    rename_table :projects, :actions
    rename_column :actions, :parent_project_id, :parent_action_id
    rename_column :actions, :project_week_id, :action_group_id
    rename_column :users, :receive_emails_about_my_project_weeks, :receive_emails_about_my_action_groups
    rename_column :users, :receive_emails_about_project_weeks, :receive_emails_about_action_groups
    rename_column :participations, :project_id, :action_id
    rename_column :leaderships, :project_id, :action_id

    rename_table :project_weeks, :action_groups
  end
end
