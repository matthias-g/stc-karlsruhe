class AddSlugColumnToActionGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :action_groups, :slug, :string
    add_index :action_groups, :slug, unique: true
    ActionGroup.find_each(&:save)
  end
end
