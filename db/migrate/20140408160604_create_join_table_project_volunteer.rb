class CreateJoinTableProjectVolunteer < ActiveRecord::Migration
  def change
    create_join_table :projects, :users, {:table_name => 'projects_volunteers' } do |t|
      t.index [:project_id, :user_id]
      # t.index [:user_id, :project_id]
    end
  end
end
