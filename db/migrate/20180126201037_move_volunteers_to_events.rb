class MoveVolunteersToEvents < ActiveRecord::Migration[5.1]
  def change
    rename_column :participations, :action_id, :event_id
    participation_ids_to_delete = []
    Participation.all.each do |participation|
      action_id = participation.read_attribute('event_id')
      user_id = participation.read_attribute('user_id')
      unless Action.exists?(action_id) && User.exists?(user_id)
        participation_ids_to_delete << action_id
        next
      end
      action = Action.find(action_id)
      unless action.events.count > 0
        Event.create!(date: action.date, time: action.time, initiative: action)
      end
      participation.update_column('event_id', action.events.first.id)
    end

    participation_ids_to_delete.each do |participation_id|
      Participation.delete(participation_id)
    end
  end
end
