class MoveFieldsFromActionToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :desired_team_size, :integer
    add_column :events, :team_size, :integer

    Action.all.each do |action|
      next if action.subactions.count > 0
      unless action.events.count > 0
        Event.create!(date: action.date, time: action.time, initiative: action)
      end
      event = action.events.first
      event.update_column('date', action.read_attribute('date'))
      event.update_column('time', action.read_attribute('time'))
      event.update_column('desired_team_size', action.read_attribute('desired_team_size'))
    end

    reversible do |dir|
      dir.up {
        execute <<-SQL.squish
        UPDATE events
           SET team_size = (SELECT count(1)
                             FROM participations
                            WHERE participations.event_id = events.id)
        SQL
      }
    end

    remove_column :actions, :date
    remove_column :actions, :time
    remove_column :actions, :desired_team_size
    remove_column :actions, :team_size
  end
end
