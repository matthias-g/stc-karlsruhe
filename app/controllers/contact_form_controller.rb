class ContactFormController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      Mailer.contact_mail(@message).deliver
      redirect_to root_path, notice: t('contact.success')
    else
      redirect_to contact_path, notice: t('contact.fail')
    end
  end

end
