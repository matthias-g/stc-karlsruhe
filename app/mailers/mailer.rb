class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER

  def contact_mail(message)
    @message = message.body
    recipient = StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT
    mail from: message.sender, to: recipient, reply_to: message.sender, subject: message.subject
  end

  def contact_mail_copy_for_sender(message)
    @message = message.body
    mail to: message.sender, subject: message.subject
  end

  def project_mail(message, sender, project)
    @message = message.body
    @project_title = project.title
    @sender = sender
    recipients = (project.volunteers + project.leaders + [sender]).map{|v| v.email}.uniq.join(',')
    mail bcc: recipients, reply_to: sender.email, subject: message.subject
  end

  def user_mail(message, sender, recipient)
    @message = message.body
    @sender = sender
    @recipient = recipient
    mail to: recipient.email, reply_to: sender.email, subject: message.subject
  end

  def generic_mail(message, bcc = nil)
    @message = message.body
    if bcc
      mail from: message.sender, bcc: message.recipient, subject: message.subject
    else
      mail from: message.sender, to: message.recipient, subject: message.subject
    end
  end

  def leaving_project_notification(user, project)
    @user = user
    @project = project
    recipients = (project.leaders.pluck(:email) + [StcKarlsruhe::Application::NOTIFICATION_RECIPIENT]).uniq.join(',')
    mail bcc: recipients, subject: t('project.message.leavingProjectNotification.subject')
  end

  def gallery_picture_uploaded_notification(gallery, picture_count, uploader)
    @uploader = uploader
    @gallery = gallery
    @picture_count = picture_count
    @title = gallery.title
    @title = gallery.projects.collect{ |p| p.title }.join(', ') if @title.blank?
    @title = gallery.news_entries.collect{ |p| p.title }.join(', ') if @title.blank?
    @type = 'Projekts' if gallery.projects.any?
    @type = 'Newseintrags' if gallery.news_entries.any?
    mail to: StcKarlsruhe::Application::NOTIFICATION_RECIPIENT, subject: t('project.message.mailNewPictures.subject', pictureCount: picture_count)
  end

end
