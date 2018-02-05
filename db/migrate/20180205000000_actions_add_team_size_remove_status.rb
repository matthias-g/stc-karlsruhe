class ActionsAddTeamSizeRemoveStatus < ActiveRecord::Migration[5.1]
  def change
    remove_column :actions, :total_team_size, :integer, default: 0
    remove_column :actions, :total_desired_team_size, :integer, default: 0
    remove_column :actions, :status, :integer, default: 1
    add_column :actions, :team_size, :integer, default: 0
    Action.all.each(&:save!)
  end
end
