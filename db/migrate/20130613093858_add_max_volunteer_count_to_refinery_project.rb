class AddMaxVolunteerCountToRefineryProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :max_volunteer_count, :integer
  end
end
