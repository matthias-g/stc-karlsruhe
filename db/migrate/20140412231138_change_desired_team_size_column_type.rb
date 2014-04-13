class ChangeDesiredTeamSizeColumnType < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE projects ALTER COLUMN desired_team_size TYPE integer USING (desired_team_size::integer)'
  end

  def down
    execute 'ALTER TABLE projects ALTER COLUMN desired_team_size TYPE text USING (latitude::text)'
  end
end
