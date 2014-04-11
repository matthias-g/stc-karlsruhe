class CreateJoinTableUsersRoles < ActiveRecord::Migration
  def change
    create_join_table :users, :roles do |t|
      t.contact [:user_id, :role_id]
    end
  end
end
