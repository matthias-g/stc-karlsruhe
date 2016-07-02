class AddEmailSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_emails_about_project_weeks, :boolean, default: true
    add_index :users, :receive_emails_about_project_weeks
    add_column :users, :receive_emails_about_my_project_weeks, :boolean, default: true
    add_index :users, :receive_emails_about_my_project_weeks
    add_column :users, :receive_emails_about_other_projects, :boolean, default: true
    add_index :users, :receive_emails_about_other_projects
    add_column :users, :receive_other_emails_from_orga, :boolean, default: true
    add_index :users, :receive_other_emails_from_orga
    add_column :users, :receive_emails_from_other_users, :boolean, default: true
    add_index :users, :receive_emails_from_other_users
  end
end
