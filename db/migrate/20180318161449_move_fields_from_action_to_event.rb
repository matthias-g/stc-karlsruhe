class MoveFieldsFromActionToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :desired_team_size, :integer
    add_column :events, :team_size, :integer

    Action.all.each do |action|
      unless action.events.count > 0
        Event.create!(date: action.date, time: action.time, initiative: action)
      end
      event = action.events.first
      event.update_column('date', action.date)
      event.update_column('time', action.time)
      event.update_column('desired_team_size', action.desired_team_size)
      event.update_column('team_size', action.team_size)
    end

    remove_column :actions, :date
    remove_column :actions, :time
    remove_column :actions, :desired_team_size
    remove_column :actions, :team_size
  end
end
