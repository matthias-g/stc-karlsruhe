class AddEventTeamSizeDefault < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up {
        execute "UPDATE events SET team_size = 0 WHERE team_size IS NULL;"
      }
    end

    change_column_default :events, :team_size, 0
    change_column_null :events, :team_size, false
  end
end
