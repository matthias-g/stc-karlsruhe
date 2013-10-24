class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.string :individual_tasks
      t.string :requirements

      t.timestamps
    end
  end
end
