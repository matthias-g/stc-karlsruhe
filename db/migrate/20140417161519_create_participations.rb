class Participation < ActiveRecord::Base; end

class CreateParticipations < ActiveRecord::Migration
  def change
    create_table(:participations, id: false) do |t|
      t.references :user
      t.references :project
      t.boolean :as_leader, default: false

      t.index [:user_id, :project_id, :as_leader], unique: true

      t.timestamps
    end

    reversible do |migration|
      migration.up do
        execute "insert into participations (user_id, project_id) select user_id, project_id from projects_leaders;"
        Participation.update_all as_leader: true
        execute "insert into participations (user_id, project_id) select user_id, project_id from projects_volunteers;"
      end

      migration.down do
        Participation.all.each do |p|
          execute "insert into #{p.as_leader ? 'projects_leaders' : 'projects_volunteers'} (user_id, project_id) values (#{p.user_id}, #{p.project_id});"
        end
      end
    end

    drop_join_table :projects, :users, {:table_name => 'projects_volunteers' } do |t|
      t.index [:project_id, :user_id]
    end
    drop_join_table :projects, :users, {:table_name => 'projects_leaders' }  do |t|
      t.index [:project_id, :user_id]
    end
  end
end
