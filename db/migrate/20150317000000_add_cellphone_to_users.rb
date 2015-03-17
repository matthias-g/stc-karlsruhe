class AddCellphoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string, :default => ''
  end
end