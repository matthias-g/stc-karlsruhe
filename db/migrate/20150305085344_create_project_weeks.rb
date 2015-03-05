class CreateProjectWeeks < ActiveRecord::Migration
  def change
    create_table :project_weeks do |t|
      t.string :title
      t.boolean :default

      t.timestamps
    end
  end
end
