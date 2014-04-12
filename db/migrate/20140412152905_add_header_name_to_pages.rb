class AddHeaderNameToPages < ActiveRecord::Migration
  def change
    add_column :pages, :header_name, :string
  end
end
