class AddIndividualTasksAndRequirementsAndMaterialToRefineryProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :individual_tasks, :text
    add_column :refinery_projects, :requirements, :text
    add_column :refinery_projects, :material, :text
  end
end
