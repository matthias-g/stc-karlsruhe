class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER
  layout false, only: 'orga_mail'
  add_template_helper(OrgaMessagesHelper)

  def contact_orga_mail(body, subject, sender)
    @message = body
    recipient = StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT
    mail to: recipient, reply_to: sender, subject: subject
  end

  def contact_orga_mail_copy_for_sender(body, subject, sender)
    @message = body
    mail to: sender, subject: t('mailer.contact_orga_mail_copy_for_sender.subject', subject: subject)
  end

  def contact_volunteers_mail(body, subject, sender, recipient, action)
    @message = replace_user_placeholder(body, recipient.first_name)
    @action_title = action.full_title
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email,
         subject: replace_user_placeholder(subject, recipient.first_name)
  end

  def contact_leaders_mail(body, subject, sender, recipient, action)
    @message = body
    @sender = sender
    @recipient = recipient
    @action_title = action.full_title
    mail to: recipient.email, reply_to: sender.email, subject: subject
  end

  def user_mail(body, subject, sender, recipient)
    @message = body
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email, subject: subject
  end

  def orga_user_mail(orga_message, user)
    @message = replace_user_placeholder(orga_message.body, user.first_name)
    @user = user
    @type = orga_message.content_type
    mail to: user.email, reply_to: orga_message.from,
         subject: replace_user_placeholder(orga_message.subject, user.first_name)
  end

  def orga_subscription_mail(orga_message, subscription)
    @message = replace_user_placeholder(orga_message.body, subscription.name)
    @subscription = subscription
    @type = orga_message.content_type
    mail to: subscription.email, reply_to: orga_message.from,
         subject: replace_user_placeholder(orga_message.subject, subscription.name)
  end

  def orga_mail_notification(orga_message, recipient)
    @recipient = recipient
    mail to: recipient.email, reply_to: orga_message.from,
         subject: t('mailer.orga_mail_notification.subject', subject: orga_message.subject)
  end

  # reminder email to a user when he/she joins an action
  def event_join_reminder(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: t('mailer.event_join_reminder.subject')
  end

  # notification when a user joins an event
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
    @title = gallery.owner&.title || gallery.title
    @type = 'einer Aktion' if gallery.owner_type == 'Action'
    @type = 'eines Projekts' if gallery.owner_type == 'Project'
    @type = 'eines Newseintrags' if gallery.owner_type == 'NewsEntry'
    recipient = StcKarlsruhe::Application::NOTIFICATION_RECIPIENT
    mail to: recipient, subject: t('mailer.gallery_picture_uploaded_notification.subject', pictureCount: picture_count)
  end

  private

  def replace_user_placeholder(text, name)
    text.gsub('{user}', name.titleize)
  end

end
