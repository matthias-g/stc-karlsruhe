class CreateNewsEntries < ActiveRecord::Migration
  def change
    create_table :news_entries do |t|
      t.string :title
      t.string :teaser
      t.string :text
      t.string :picture
      t.string :picture_source
      t.integer :category
      t.boolean :visible
      t.string :slug
      t.index :slug
      t.timestamps null: false
    end
  end
end
