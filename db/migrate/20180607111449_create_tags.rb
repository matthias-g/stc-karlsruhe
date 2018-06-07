class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :title
      t.string :icon
      t.string :color

      t.timestamps
    end

    create_join_table :initiatives, :tags do |t|
      t.index :initiative_id
      t.index :tag_id
    end
  end
end
