class AddParentProjectToProject < ActiveRecord::Migration
  def change
    add_column :projects, :parent_project_id, :integer
  end
end
