class CreateProjectFlags < ActiveRecord::Migration
  def change
    create_table :project_flags do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
