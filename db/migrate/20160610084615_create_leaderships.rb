class CreateLeaderships < ActiveRecord::Migration
  def change

    create_table :leaderships do |t|
      t.references :user
      t.references :action

      t.index [:user_id, :project_id], unique: true

      t.timestamps
    end

    reversible do |migration|
      migration.up do
        execute "insert into leaderships (user_id, project_id, created_at, updated_at)
                  select user_id, project_id, created_at, updated_at from participations where as_leader = 'true';"
        Participation.destroy_all as_leader: true
      end

      migration.down do
        Leadership.all.each do |l|
          created_at = quoted_value_or_null l.created_at
          updated_at = quoted_value_or_null l.updated_at
          project_id = quoted_value_or_null l.project_id
          execute "insert into participations (user_id, project_id, created_at, updated_at, as_leader)
                     values (#{l.user_id}, #{project_id}, #{created_at}, #{updated_at}, true);"
        end
      end
    end

    remove_index :participations, column: [:user_id, :project_id, :as_leader], unique: true
    remove_column :participations, :as_leader, :boolean, default: false
  end

  private

  def quoted_value_or_null value
    if value.blank?
      'NULL'
    else
      "'" + value.to_s + "'"
    end
  end

end
