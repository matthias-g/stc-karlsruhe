class AddImageToRefineryUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :image_id, :integer
  end
end
