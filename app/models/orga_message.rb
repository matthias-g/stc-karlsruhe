class OrgaMessage < ApplicationRecord
  include OrgaMessagesHelper

  belongs_to :author, class_name: 'User'
  belongs_to :sender, class_name: 'User', optional: true

  validates :from, :recipient, :content_type, :subject, :body, :author, presence: true, allow_blank: false

  def sent?
    sent_at != nil
  end

  def send_message(sender)
    self.sender = sender
    recipient_list = recipients(sender)
    recipient_list.each do |recipient|
      #TODO: use a crash safe ActiveJob Backend
      Mailer.orga_mail(self, recipient).deliver_later
    end
    # completion email
    Mailer.orga_mail_notification(self, sender).deliver_later

    # recipient: group symbol -> list of user IDs
    # sent_to: rendered group label
    self.sent_to = render_recipient_group(self.recipient, sender)
    self.recipient = recipient_list.map(&:id).join(',')
    self.sent_at = Time.now
    self.save
  end

  def recipients(sender)
    # find users by recipient group
    current_action_ids = ActionGroup.default.actions.visible.pluck(:id)
    user_query = case self.recipient.to_sym
      when :current_volunteers_and_leaders
        User.left_joins(:leaderships, :events_as_volunteer)
            .where('leaderships.action_id IN (?) OR events.initiative_id IN (?)',
                   current_action_ids, current_action_ids)
      when :current_volunteers
        User.joins(:events_as_volunteer).where(events: {initiative_id: current_action_ids})
      when :current_leaders
        User.joins(:leaderships).where(leaderships: {action_id: current_action_ids})
      when :all_users
        User.all
      when :active_users
        User.left_joins(:participations)
            .where('participations.created_at > ? OR users.created_at > ?', 18.months.ago, 6.months.ago)
      when :test
        return User.where(id: sender.id).to_a * 1000
      when :me
        return User.where(id: sender.id)
      else
        return self.recipient.split(/\s*,\s*/).map(&:to_i).collect {|id| User.find(id) }
    end

    # filter users by email preferences
    filtered_user_query = case self.content_type.to_sym
    when :about_action_groups
      if %w(current_volunteers_and_leaders current_volunteers current_leaders).include?(self.recipient)
        user_query.where('users.receive_emails_about_my_action_groups': true)
      else
        user_query.where('users.receive_emails_about_action_groups': true)
      end
    when :about_other_actions
      user_query.where('users.receive_emails_about_other_actions': true)
    else
      user_query.where('users.receive_other_emails_from_orga': true)
    end

    return filtered_user_query.valid.order(:id).uniq
  end

end
