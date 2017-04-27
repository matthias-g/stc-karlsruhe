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

  def orga_mail(message)
    current_projects = ProjectWeek.default.projects.visible
    case message.recipient
      when 'current_volunteers_and_leaders'
        to = current_projects.joins('LEFT OUTER JOIN participations ON projects.id = participations. project_id')
                 .joins('LEFT OUTER JOIN leaderships ON projects.id = leaderships.project_id')
                 .joins('INNER JOIN "users" ON "users"."id" = "participations"."user_id" OR "users"."id" = "leaderships"."user_id"')
                 .where('users.cleared': false)
      when 'current_volunteers'
        to = current_projects.joins(:volunteers).where('users.cleared': false)
      when 'current_leaders'
        to = current_projects.joins(:leaders).where('users.cleared': false)
      when 'all_users'
        to = User.where(cleared: false).all
      when 'active_users'
        to = User.where(cleared: false).joins('LEFT JOIN participations on participations.user_id = users.id').where('participations.created_at > ? or users.created_at > ?', 18.months.ago, 6.months.ago) # TODO Rails 5
      when 'me'
        to = User.where(id: message.sender.id)
      else
        to = message.recipient.split(/\s*,\s*/)
    end
    unless to.kind_of?(Array)
      case message.content_type
        when 'about_project_weeks'
          if %w(current_volunteers_and_leaders current_volunteers current_leaders).include? message.recipient
            to = to.where('users.receive_emails_about_my_project_weeks': true)
          else
            to = to.where('users.receive_emails_about_project_weeks': true)
          end
        when 'about_other_projects'
          to = to.where('users.receive_emails_about_other_projects': true)
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
    mail from: message.from, bcc: recipients, subject: message.subject
  end

  def leaving_project_notification(user, project)
    @user = user
    @project = project
    recipients = (project.leaders.where('users.receive_notifications_for_users_leaving_project': true).pluck(:email) +
        [StcKarlsruhe::Application::NOTIFICATION_RECIPIENT])
                     .uniq.join(',')
    mail bcc: recipients, subject: t('project.message.leavingProjectNotification.subject')
  end

  def project_participate_notification(user, project)
    @user = user
    @project = project
    recipients = user.email
    mail bcc: recipients, subject: t('project.message.projectParticipateNotification.subject')
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
