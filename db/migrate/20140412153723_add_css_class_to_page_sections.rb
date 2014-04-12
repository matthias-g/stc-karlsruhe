class AddCssClassToPageSections < ActiveRecord::Migration
  def change
    add_column :page_sections, :css_class, :string
  end
end
