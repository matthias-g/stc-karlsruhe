class AddMapInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :map_latitude, :float, :default => 49.01347014
    add_column :projects, :map_longitude, :float, :default => 8.40445518
    add_column :projects, :map_zoom, :integer, :default => 12
  end
end