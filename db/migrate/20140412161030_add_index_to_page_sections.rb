class AddIndexToPageSections < ActiveRecord::Migration
  def change
    add_column :page_sections, :index, :integer
  end
end
