class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :location
      t.float :latitude
      t.float :longitude
      t.text :individual_tasks
      t.text :material
      t.text :requirements
      t.boolean :visible

      t.timestamps
    end
  end
end
