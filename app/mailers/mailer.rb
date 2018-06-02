class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER
  layout false, only: 'orga_mail'
  add_template_helper(OrgaMessagesHelper)

  def contact_orga_mail(body, sender, subject)
    @message = body
    recipient = StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT
    mail to: recipient, reply_to: sender, subject: subject
  end

  def contact_orga_mail_copy_for_sender(body, sender, subject)
    @message = body
    mail to: sender, subject: t('mailer.contact_orga_mail_copy_for_sender.subject', subject: subject)
  end

  def contact_volunteers_mail(message, sender, recipient, action)
    @message = replace_variables(message.body, recipient)
    @action_title = action.full_title
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email, subject: replace_variables(message.subject, recipient)
  end

  def contact_leaders_mail(message, sender, recipient, action)
    @message = message.body
    @sender = sender
    @recipient = recipient
    @action_title = action.full_title
    mail to: recipient.email, reply_to: sender.email, subject: message.subject
  end

  def user_mail(message, sender, recipient)
    @message = message.body
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email, subject: message.subject
  end

  def orga_mail(message, recipient)
    @message = replace_variables(message.body, recipient)
    @recipient = recipient
    @type = message.content_type
    mail to: recipient.email, reply_to: message.from,
         subject: replace_variables(message.subject, recipient)
  end

  def orga_mail_notification(message, recipient)
    @recipient = recipient
    mail to: recipient.email, reply_to: message.from,
         subject: t('mailer.orga_mail_notification.subject', subject: message.subject)
  end

  # reminder email to a user when he/she joins an action
  def event_join_reminder(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: t('mailer.event_join_reminder.subject')
  end

  # notification when a user joins an action
  def event_join_notification(recipient, user, event)
    @recipient = recipient
    @user = user
    @event = event
    mail to: recipient.email, subject: t('mailer.event_join_notification.subject', action: event.initiative.title)
  end

  # notification when a user leaves an action
  def event_leave_notification(recipient, user, event)
    @recipient = recipient
    @user = user
    @event = event
    mail to: recipient.email, subject: t('mailer.event_leave_notification.subject')
  end

  # notification when uploader uploads some pictures
  def gallery_picture_uploaded_notification(gallery, picture_count, uploader)
    @uploader = uploader
    @gallery = gallery
    @picture_count = picture_count
    @title = gallery.title
    @title = gallery.actions.collect{ |p| p.title }.join(', ') if @title.blank?
    @title = gallery.news_entries.collect{ |p| p.title }.join(', ') if @title.blank?
    @type = 'einer Aktion' if gallery.actions.any?
    @type = 'eines Newseintrags' if gallery.news_entries.any?
    recipient = StcKarlsruhe::Application::NOTIFICATION_RECIPIENT
    mail to: recipient, subject: t('mailer.gallery_picture_uploaded_notification.subject', pictureCount: picture_count)
  end

  private

  def replace_variables(text, recipient)
    text.gsub('{user}', recipient.first_name.titleize)
  end

end
