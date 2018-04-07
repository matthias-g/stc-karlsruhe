class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :date
      t.string :time
      t.integer :initiative_id

      t.timestamps
    end
  end
end
