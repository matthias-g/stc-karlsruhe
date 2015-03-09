class DropPagesAndPageSections < ActiveRecord::Migration
  def change
    drop_table :pages
    drop_table :page_sections
  end
end
