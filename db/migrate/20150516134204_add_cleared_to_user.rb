class AddClearedToUser < ActiveRecord::Migration
  def change
    add_column :users, :cleared, :boolean, default: false
  end
end
