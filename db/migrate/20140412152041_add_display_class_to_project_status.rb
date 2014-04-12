class AddDisplayClassToProjectStatus < ActiveRecord::Migration
  def change
    add_column :project_statuses, :display_class, :string
  end
end
