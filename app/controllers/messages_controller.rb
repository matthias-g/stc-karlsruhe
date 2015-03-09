class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      Mailer.contact_mail(@message).deliver
      redirect_to root_path, notice: t('contact.orga.success')
    else
      flash[:alert] = @message.errors.values
      redirect_to kontakt_path
    end
  end

end
