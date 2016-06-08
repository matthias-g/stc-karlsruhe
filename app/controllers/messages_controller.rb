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
    @recipients = ['current_volunteers_and_leaders', 'current_volunteers',
                   'current_leaders', 'all_users', 'active_users']
  end

  def send_admin_mail
    current_projects = ProjectWeek.default.projects.visible
    case @message.recipient
      when 'current_volunteers_and_leaders'
        to = current_projects.joins(:users).where('users.cleared': false).pluck(:email)
      when 'current_volunteers'
        to = current_projects.joins(:users).where('users.cleared': false).where('participations.as_leader = false').pluck(:email)
      when 'current_leaders'
        to = current_projects.joins(:users).where('users.cleared': false).where('participations.as_leader = true').pluck(:email)
      when 'all_users'
        to = User.where(cleared: false).all.pluck(:email)
      when 'active_users'
        to = User.where(cleared: false).where('created_at > ?', 6.months.ago).pluck(:email) +
             User.where(cleared: false).joins(:projects).where('participations.created_at > ?', 18.months.ago).pluck(:email)
      else
        to = @message.recipient.split(/\s*,\s*/)
    end
    @message.recipient = (to + [current_user.email]).uniq.join(',')
    if @message.valid?
      Mailer.generic_mail(@message, true).deliver_now
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
