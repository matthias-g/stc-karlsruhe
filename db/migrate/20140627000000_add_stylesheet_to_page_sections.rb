class AddStylesheetToPageSections < ActiveRecord::Migration
  def change
    add_column :page_sections, :stylesheet, :text, :default => ''
  end
end