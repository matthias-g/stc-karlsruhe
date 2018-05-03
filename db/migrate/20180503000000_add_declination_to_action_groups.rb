class AddDeclinationToActionGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :action_groups, :declination, :integer, default: 0
  end
end
