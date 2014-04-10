class FixSpellingUserNames < ActiveRecord::Migration
  def change
    rename_column :users, :forename, :first_name
    rename_column :users, :lastname, :last_name
  end
end
