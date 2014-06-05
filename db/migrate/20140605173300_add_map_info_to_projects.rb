class AddMapInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :map_latitude, :float
    add_column :projects, :map_longitude, :float
    add_column :projects, :map_zoom, :integer
  end
end