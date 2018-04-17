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

  def orga_mail(message, recipients)
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
