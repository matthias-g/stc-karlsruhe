class AddSentToToOrgaMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :orga_messages, :sent_to, :string, default: ''

    reversible do |dir|
      dir.up {
        execute "UPDATE orga_messages SET sent_to = recipient, recipient = '' WHERE sent_at IS NOT NULL"
      }
      dir.down {
        execute "UPDATE orga_messages SET recipient = sent_to WHERE sent_at IS NOT NULL"
      }
    end
  end
end
