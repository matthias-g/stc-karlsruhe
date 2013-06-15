class AddForenameAndSurnameToRefineryUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :forename, :string
    add_column :refinery_users, :surname, :string
  end
end
