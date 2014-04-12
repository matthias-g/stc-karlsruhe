class AddPartialNameToPageSections < ActiveRecord::Migration
  def change
    add_column :page_sections, :partial_name, :string
  end
end
