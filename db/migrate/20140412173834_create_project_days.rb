class CreateProjectDays < ActiveRecord::Migration
  def change
    create_table :project_days do |t|
      t.string :title

      t.timestamps
    end
  end
end
