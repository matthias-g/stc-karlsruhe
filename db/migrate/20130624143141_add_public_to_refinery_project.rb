class AddPublicToRefineryProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :public, :boolean, :default => false
  end
end
