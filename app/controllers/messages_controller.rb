class MessagesController < ApplicationController

  before_action :authenticate_admin_user!, only: [:send_to_all]

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

  def send_to_all
    @message = Message.new(params[:message])
    @message.sender = current_user.email
    @message.recipient = User.all.map { |v| v.email}.uniq.join(',') + ',' + current_user.email
    if @message.valid?
      Mailer.multi_user_bcc_mail(@message, current_user.full_name, "").deliver
      flash[:notice] = "Sent mail to all"
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.values
      render action: :show
    end
  end

end
