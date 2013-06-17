class AddUserToRefineryImage < ActiveRecord::Migration
  def change
    add_column :refinery_images, :user_id, :integer
  end
end
