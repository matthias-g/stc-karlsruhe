class AddShortDescriptionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :short_description, :text, :default => ''
  end
end
