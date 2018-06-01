class OrgaMessage < ApplicationRecord
  include OrgaMessagesHelper

  belongs_to :author, class_name: 'User'
  belongs_to :sender, class_name: 'User', optional: true
  belongs_to :action_group

  validates :from, :recipient, :action_group, :content_type, :subject, :body, :author, presence: true, allow_blank: false

  def sent?
    sent_at != nil
  end

  def send_message(sender)
    self.sender = sender
    recipient_list = recipients(sender)
    recipient_list.each do |recipient|
      Mailer.orga_mail(self, recipient).deliver_later
    end
    # completion email
    Mailer.orga_mail_notification(self, sender).deliver_later

    if recipient.to_sym != :sender
      self.sent_to = recipient_list.map(&:id).join(',')
      self.sent_at = Time.now
    end
    self.save
  end

  def recipients(sender)
    # reconstruct recipients if message was already sent
    if sent?
      return sent_to.split(/\s*,\s*/).map(&:to_i).collect {|id| User.find(id) }
    end

    # find users by recipient group
    current_action_ids = ActionGroup.default.actions.visible.pluck(:id)
    user_query = case recipient.to_sym
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
      when :sender
        return User.where(id: sender.id)
      else
        return User.none
    end

    # filter users by email preferences
    filtered_user_query = case content_type.to_sym
    when :about_action_groups
      if %w(current_volunteers_and_leaders current_volunteers current_leaders).include?(recipient)
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
