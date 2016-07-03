class MessagesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:admin_mail_form, :send_admin_mail]
  before_action :set_message, only: [:send_contact_mail, :send_admin_mail]
  before_action :block_spam, only: [:send_contact_mail]

  def contact_mail_form
    @message = Message.new
  end

  def send_contact_mail
    if @message.valid?
      Mailer.contact_mail(@message).deliver_now
      Mailer.contact_mail_copy_for_sender(@message).deliver_now
      redirect_to root_path, notice: t('contact.orga.success')
    else
      flash[:alert] = @message.errors.values
      redirect_to kontakt_path
    end
  end

  def admin_mail_form
    @message = Message.new
    @senders = ['Serve the City Karlsruhe <contact@servethecity-karlsruhe.de>',
                'Serve the City Karlsruhe <orga@servethecity-karlsruhe.de>',
                'Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>',
                current_user.full_name+ ' <' + current_user.email + '>']
    @recipients = %w(current_volunteers_and_leaders current_volunteers current_leaders all_users active_users me)
    @types = %w(about_project_weeks about_other_projects other_email_from_orga)
  end

  def send_admin_mail
    current_projects = ProjectWeek.default.projects.visible
    case @message.recipient
      when 'current_volunteers_and_leaders'
        to = current_projects.joins(:users).where('users.cleared': false)
      when 'current_volunteers'
        to = current_projects.joins(:users).where('users.cleared': false).where('participations.as_leader = false')
      when 'current_leaders'
        to = current_projects.joins(:users).where('users.cleared': false).where('participations.as_leader = true')
      when 'all_users'
        to = User.where(cleared: false).all
      when 'active_users'
        to = User.where(cleared: false).joins(:projects).where('participations.created_at > ? or participations.created_at > ?', 18.months.ago, 6.months.ago) # TODO Rails 5
      when 'me'
        to = User.where(id: current_user.id)
      else
        to = @message.recipient.split(/\s*,\s*/)
    end
    case @message.type
      when 'about_project_weeks'
        if %w(current_volunteers_and_leaders current_volunteers current_leaders).include? @message.recipient
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
    @message.recipient = (to.pluck(:email) + [current_user.email]).uniq.join(',')
    if @message.valid?
      Mailer.admin_mail(@message).deliver_now
      flash[:notice] = t('contact.adminMail.success')
      redirect_to action: :admin_mail_form
    else
      flash[:alert] = @message.errors.values
      redirect_to action: :admin_mail_form
    end
  end

  def set_message
    @message = Message.new(params[:message])
  end

  def block_spam
    unless user_signed_in? || verify_recaptcha(model: @message)
      flash.now[:error] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      render :contact_mail_form
    end
  end

end
