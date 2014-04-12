class ChangeDesiredTeamSizeColumnType < ActiveRecord::Migration
  def change
    change_column :projects, :desired_team_size, :integer
  end
end
