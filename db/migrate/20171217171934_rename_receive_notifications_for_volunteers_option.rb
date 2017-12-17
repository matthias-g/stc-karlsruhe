class RenameReceiveNotificationsForVolunteersOption < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :receive_notifications_for_users_leaving_project, :receive_notifications_about_volunteers
  end
end
