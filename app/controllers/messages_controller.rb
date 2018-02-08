class MessagesController < ApplicationController
  before_action :set_message, only: [:send_contact_mail]
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
      flash[:alert] = @message.errors.full_messages
      redirect_to contact_path
    end
  end

  def set_message
    @message = Message.new(params[:message])
  end

  def block_spam
    unless user_signed_in? || verify_recaptcha(model: @message)
      render :contact_mail_form
    end
  end

end
