class AddActionGroupIdToOrgaMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :orga_messages, :action_group_id, :integer

    OrgaMessage.all.each do |msg|
      sent_to = msg.recipient
      recipient = :all_users
      action_group = ActionGroup.where(start_date: (msg.sent_at.to_date - 100)..(msg.sent_at.to_date + 100)).first
      action_group = ActionGroup.default unless action_group

      case msg.sent_to.gsub('Projekt', 'Aktions')
      when 'Alle angemeldeten Benutzer'
        recipient = :all_users
      when /^Aktive Benutzer/
        recipient = :active_users
      when /^Ich/
        recipient = :sender
      when /^Test/
        recipient = :test
      when /^Mitarbeiter (der|-) (.*)/
        recipient = :current_volunteers
        action_group = ActionGroup.find_by(title: $2)
      when /^Aktionsleiter und Mitarbeiter (der|-) (.*)/
        recipient = :current_volunteers_and_leaders
        action_group = ActionGroup.find_by(title: $2)
      when /^Aktionsleiter (der|-) (.*)/
        recipient = :current_leaders
        action_group = ActionGroup.find_by(title: $2)
      end

      msg.recipient = recipient
      msg.sent_to = sent_to
      msg.action_group = action_group
      msg.save!
    end
  end
end
