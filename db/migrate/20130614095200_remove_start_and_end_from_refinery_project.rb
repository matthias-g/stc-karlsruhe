class RemoveStartAndEndFromRefineryProject < ActiveRecord::Migration
  def up
    remove_column :refinery_projects, :start
    remove_column :refinery_projects, :end
  end

  def down
    add_column :refinery_projects, :end, :datetime
    add_column :refinery_projects, :start, :datetime
  end
end
