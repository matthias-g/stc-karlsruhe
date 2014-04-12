class CreatePageSections < ActiveRecord::Migration
  def change
    create_table :page_sections do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
