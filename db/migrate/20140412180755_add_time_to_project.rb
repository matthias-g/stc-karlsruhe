class AddTimeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :time, :string
  end
end
