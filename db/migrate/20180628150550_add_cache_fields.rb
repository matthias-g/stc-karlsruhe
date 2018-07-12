class AddCacheFields < ActiveRecord::Migration[5.2]
  def change
    add_column :action_groups, :action_count, :integer, default: 0
    add_column :action_groups, :active_user_count, :integer, default: 0
    add_column :action_groups, :available_places_count, :integer, default: 0
    add_column :initiatives, :subaction_count, :integer, default: 0
    Action.find_each(&:update_cache_fields)
    ActionGroup.find_each(&:update_cache_fields)
  end
end
