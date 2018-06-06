class AddIconToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :initiatives, :icon, :string
  end
end
