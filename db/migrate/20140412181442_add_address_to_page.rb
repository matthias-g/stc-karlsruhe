class AddAddressToPage < ActiveRecord::Migration
  def change
    add_column :pages, :address, :string
  end
end
