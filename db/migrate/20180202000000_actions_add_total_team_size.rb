class ActionsAddTotalTeamSize < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :total_team_size, :integer, default: 0
    add_column :actions, :total_desired_team_size, :integer, default: 0
  end
end
