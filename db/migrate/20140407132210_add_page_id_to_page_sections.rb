class AddPageIdToPageSections < ActiveRecord::Migration
  def change
    add_column :page_sections, :page_id, :integer
  end
end
