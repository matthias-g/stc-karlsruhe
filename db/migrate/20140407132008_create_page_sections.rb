class CreatePageSections < ActiveRecord::Migration
  def change
    create_table :page_sections do |t|
      t.string :title
      t.text :message

      t.timestamps
    end
  end
end
