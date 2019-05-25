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
    recipient_list = calculate_recipients_for_sender(sender)
    recipient_list.each do |recipient|
      if newsletter?
        Mailer.orga_subscription_mail(self, recipient).deliver_later
      else
        Mailer.orga_user_mail(self, recipient).deliver_later
      end
    end
    # completion email
    Mailer.orga_mail_notification(self, sender).deliver_later

    if recipient.to_sym != :sender
      self.sent_to = recipient_list.map(&:id).join(',')
      self.sent_at = Time.now
    end
    self.save
  end

  def calculate_recipients_for_sender(sender)
    return recipients_for_sent_mail if sent?
    return recipients_for_newsletter if newsletter?
    recipients_for_user_mail(sender)
  end

  def newsletter?
    :newsletter == recipient.to_sym
  end

  private

  # This does not include users or subscriptions which have been deleted since sending the mail
  def recipients_for_sent_mail
    ids = sent_to.split(/\s*,\s*/).map(&:to_i)
    if newsletter?
      Subscription.where(id: ids)
    else
      User.where(id: ids)
    end
  end

  def recipients_for_newsletter
    query = Subscription.confirmed
    query = case content_type.to_sym
            when :about_action_groups
              query.where('subscriptions.receive_emails_about_action_groups': true)
            when :about_other_actions
              query.where('subscriptions.receive_emails_about_other_actions': true)
            else
              query.where('subscriptions.receive_other_emails_from_orga': true)
            end

    query.order(:id).uniq
  end

  def recipients_for_user_mail(sender)
    current_action_ids = ActionGroup.default.actions.visible.pluck(:id)
    query = case recipient.to_sym
            when :current_volunteers_and_leaders
              User.left_joins(:leaderships, :events_as_volunteer)
                  .where('leaderships.initiative_id IN (?) OR events.initiative_id IN (?)',
                         current_action_ids, current_action_ids)
            when :current_volunteers
              User.joins(:events_as_volunteer).where(events: {initiative_id: current_action_ids})
            when :current_leaders
              User.joins(:leaderships).where(leaderships: {initiative_id: current_action_ids})
            when :sender
              return User.where(id: sender.id)
            when :test
              return User.where(id: sender.id).to_a * 1000
            else
              return User.none
            end

    if content_type.to_sym == :about_action_groups &&
        %w(current_volunteers_and_leaders current_volunteers current_leaders).include?(recipient)
      query = query.where('users.receive_emails_about_my_action_groups': true)
    end

    query.valid.order(:id).uniq
  end

end
