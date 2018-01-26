class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :date
      t.string :time
      t.integer :initiative_id

      t.timestamps
    end

    Action.all.each do |action|
      if action.desired_team_size > 0
        Event.create!(date: action.date, time: action.time, initiative: action)
      end
    end
  end
end
