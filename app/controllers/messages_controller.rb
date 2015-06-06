class MessagesController < ApplicationController

  before_action :authenticate_admin_user!, only: [:send_to_all_volunteers]

  def new
    @message = Message.new
  end

  def send_to_orga
    @message = Message.new(params[:message])
    if @message.valid?
      Mailer.contact_mail(@message).deliver
      redirect_to root_path, notice: t('contact.orga.success')
    else
      flash[:alert] = @message.errors.values
      redirect_to kontakt_path
    end
  end

  def send_to_all_volunteers
    @message = Message.new(params[:message])
    @message.sender = current_user.email
    @message.recipient = ProjectWeek.default.projects.visible.joins(:users).pluck(:email).uniq.join(',') + ',' + current_user.email
    if @message.valid?
      Mailer.generic_mail(@message, true).deliver
      flash[:notice] = t('contact.allActive.success')
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.values
      render action: :show
    end
  end

end
