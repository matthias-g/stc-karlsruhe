class ChangeDesiredTeamSizeColumnType < ActiveRecord::Migration

  def change
    if ActiveRecord::Base.connection.adapter_name == 'SQLite'
      change_column :projects, :desired_team_size, :integer
    elsif ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      reversible do |change|
        change.up do
          execute 'ALTER TABLE projects ALTER COLUMN desired_team_size TYPE integer USING (desired_team_size::integer)'
        end
        change.down do
          execute 'ALTER TABLE projects ALTER COLUMN desired_team_size TYPE text USING (latitude::text)'
        end
      end
    elsif ActiveRecord::Base.connection.adapter_name == 'MySQL'
      reversible do |change|
        change.up do
          execute 'ALTER TABLE projects MODIFY desired_team_size INTEGER'
        end
        change.down do
          execute 'ALTER TABLE projects MODIFY desired_team_size TEXT'
        end
      end
    else
      adapter_name = ActiveRecord::Base.connection.adapter_name
      raise "Database adapter #{adapter_name} not supported. Migration implemented only for SQLite, PostgreSQL, and MySQL."
    end
  end

end
