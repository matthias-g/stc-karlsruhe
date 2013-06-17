class AddLatitudeAndLongitudeToRefineryProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :latitude, :float
    add_column :refinery_projects, :longitude, :float
  end
end
