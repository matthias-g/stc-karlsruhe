class CreateOrgaMessages < ActiveRecord::Migration
  def change
    create_table :orga_messages do |t|
      t.string :from
      t.string :recipient
      t.string :content_type
      t.string :subject
      t.text :body
      t.integer :author_id
      t.datetime :sent_at
      t.integer :sender_id

      t.timestamps null: false
    end
  end
end
