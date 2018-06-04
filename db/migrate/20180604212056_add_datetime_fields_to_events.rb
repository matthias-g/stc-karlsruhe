class AddDatetimeFieldsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
    Event.all.each(&:save)
  end
end
