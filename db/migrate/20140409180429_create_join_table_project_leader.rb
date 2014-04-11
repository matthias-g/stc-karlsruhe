class CreateJoinTableProjectLeader < ActiveRecord::Migration
  def change
    create_join_table :projects, :users, {:table_name => 'projects_leaders' } do |t|
      t.contact [:project_id, :user_id]
      t.index [:user_id, :project_id]
    end
  end
end
