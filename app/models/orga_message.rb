class OrgaMessage < ApplicationRecord
  include OrgaMessagesHelper

  belongs_to :author, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  validates :from, :recipient, :content_type, :subject, :body, :author, presence: true, allow_blank: false

  def sent?
    sent_at != nil
  end

  def send_message(sender)
    self.sender = sender
    send_message_in_batches
    self.sent_at = Time.now
    self.recipient = render_recipient_group(self.recipient, sender)
    self.save
  end

  private

  # TODO this could be moved to a service
  def send_message_in_batches
    current_actions = ActionGroup.default.actions.visible
    case self.recipient
    when 'current_volunteers_and_leaders'
      to = current_actions.joins(:events).joins('LEFT OUTER JOIN participations ON events.id = participations.event_id')
               .joins('LEFT OUTER JOIN leaderships ON actions.id = leaderships.action_id')
               .joins('INNER JOIN "users" ON "users"."id" = "participations"."user_id" OR "users"."id" = "leaderships"."user_id"')
               .where('users.cleared': false)
    when 'current_volunteers'
      to = current_actions.joins(:events)
               .joins('JOIN participations ON events.id = participations.event_id')
               .joins('JOIN users ON users.id = participations.user_id')
               .where('users.cleared': false)
    when 'current_leaders'
      to = current_actions.joins(:leaders).where('users.cleared': false)
    when 'all_users'
      to = User.where(cleared: false).all
    when 'active_users'
      to = User.where(cleared: false)
               .joins('LEFT JOIN participations on participations.user_id = users.id')
               .where('participations.created_at > ? or users.created_at > ?', 18.months.ago, 6.months.ago)
    when 'me'
      to = User.where(id: self.sender.id)
    else
      to = self.recipient.split(/\s*,\s*/)
    end
    unless to.kind_of?(Array)
      case self.content_type
      when 'about_action_groups'
        if %w(current_volunteers_and_leaders current_volunteers current_leaders).include?(self.recipient)
          to = to.where('users.receive_emails_about_my_action_groups': true)
        else
          to = to.where('users.receive_emails_about_action_groups': true)
        end
      when 'about_other_actions'
        to = to.where('users.receive_emails_about_other_actions': true)
      when 'other_email_from_orga'
        to = to.where('users.receive_other_emails_from_orga': true)
      else
        to = to.where('users.receive_other_emails_from_orga': true)
      end
      to = to.pluck(:email)
    end
    recipients = (to + [self.sender.email]).uniq
    recipients.in_groups_of(400) do |some_recipients|
      Mailer.orga_mail(self, some_recipients.join(',')).deliver_now
    end
  end


end
