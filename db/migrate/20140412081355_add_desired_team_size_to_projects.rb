class AddDesiredTeamSizeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :desired_team_size, :string
  end
end
