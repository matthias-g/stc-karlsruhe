class AddProjectNotificationEmailSettingsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_notifications_for_new_participation, :boolean, default: true
    add_column :users, :receive_notifications_for_users_leaving_project, :boolean, default: true
  end
end
