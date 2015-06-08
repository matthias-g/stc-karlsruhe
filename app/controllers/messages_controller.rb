class MessagesController < ApplicationController

  before_action :authenticate_admin_user!, only: [:admin_mail_form, :send_admin_mail]

  def contact_form
    @message = Message.new
  end

  def send_contact_mail
    @message = Message.new(params[:message])
    if @message.valid?
      Mailer.contact_mail(@message).deliver
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
    @message = Message.new(params[:message])
    current_projects = ProjectWeek.default.projects.visible
    case @message.recipient
      when 'current_volunteers_and_leaders'
        to = current_projects.joins(:users).pluck(:email)
      when 'current_volunteers'
        to = current_projects.joins(:users).where('participations.as_leader = false').pluck(:email)
      when 'current_leaders'
        to = current_projects.joins(:users).where('participations.as_leader = true').pluck(:email)
      when 'all_users'
        to = User.all.pluck(:email)
      when 'active_users'
        to = User.where('created_at > ?', 6.months.ago).pluck(:email) +
             User.joins(:projects).where('participations.created_at > ?', 18.months.ago).pluck(:email)
      else
        to = @message.recipient.split(/\s*,\s*/)
    end
    test = to.uniq
    @message.recipient = (to + [current_user.email]).uniq.join(',')
    if @message.valid?
      Mailer.generic_mail(@message, true).deliver
      flash[:notice] = t('contact.adminMail.success')
      redirect_to action: :admin_mail_form
    else
      flash[:alert] = @message.errors.values
      redirect_to action: :admin_mail_form
    end
  end

end
