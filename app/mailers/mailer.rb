class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER

  def contact_mail(message)
    @message = message.body
    recipient = StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT
    mail to: recipient, reply_to: message.sender, subject: message.subject
  end

  def contact_mail_copy_for_sender(message)
    @message = message.body
    mail to: message.sender, subject: message.subject
  end

  def action_mail(message, sender, action)
    @message = message.body
    @action_title = action.title
    @sender = sender
    recipients = (action.volunteers + action.leaders + [sender]).map{|v| v.email}.uniq.join(',')
    mail bcc: recipients, reply_to: sender.email, subject: message.subject
  end

  def action_mail_to_leaders(message, sender, action)
    @message = message.body
    @action_title = action.title
    @sender = sender
    recipients = (action.leaders + [sender]).map{|v| v.email}.uniq.join(',')
    mail bcc: recipients, reply_to: sender.email, subject: message.subject
  end

  def user_mail(message, sender, recipient)
    @message = message.body
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email, subject: message.subject
  end

  def orga_mail(message)
    current_actions = ActionGroup.default.actions.visible
    case message.recipient
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
        to = User.where(id: message.sender.id)
      else
        to = message.recipient.split(/\s*,\s*/)
    end
    unless to.kind_of?(Array)
      case message.content_type
        when 'about_action_groups'
          if %w(current_volunteers_and_leaders current_volunteers current_leaders).include? message.recipient
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
    recipients = (to + [message.sender.email]).uniq.join(',')
    @message = message.body
    @type = message.content_type
    mail reply_to: message.from, bcc: recipients, subject: message.subject
  end

  def leaving_action_notification(user, action)
    @user = user
    @action = action
    recipients = (action.leaders.where('users.receive_notifications_about_volunteers': true).pluck(:email) +
        [StcKarlsruhe::Application::NOTIFICATION_RECIPIENT])
                     .uniq.join(',')
    mail bcc: recipients, subject: t('action.message.action.leavingNotification.subject')
  end

  def action_participate_volunteer_notification(user, action)
    @user = user
    @action = action
    recipients = user.email
    mail bcc: recipients, subject: t('action.message.action.participateVolunteerNotification.subject')
  end

  def action_participate_leader_notification(user, action)
    @user = user
    @action = action
    recipients = action.leaders.where('users.receive_notifications_about_volunteers': true).pluck(:email).uniq.join(',')
    return if recipients.blank?
    mail bcc: recipients, subject: t('action.message.action.participateLeaderNotification.subject', {action: action.title})
  end

  def gallery_picture_uploaded_notification(gallery, picture_count, uploader)
    @uploader = uploader
    @gallery = gallery
    @picture_count = picture_count
    @title = gallery.title
    @title = gallery.actions.collect{ |p| p.title }.join(', ') if @title.blank?
    @title = gallery.news_entries.collect{ |p| p.title }.join(', ') if @title.blank?
    @type = 'Projekts' if gallery.actions.any?
    @type = 'Newseintrags' if gallery.news_entries.any?
    mail to: StcKarlsruhe::Application::NOTIFICATION_RECIPIENT, subject: t('action.message.mailNewPictures.subject', pictureCount: picture_count)
  end

end
