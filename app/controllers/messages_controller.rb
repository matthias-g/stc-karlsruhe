class MessagesController < ApplicationController
  before_action :set_message, only: [:send_contact_mail]
  before_action :block_spam, only: [:send_contact_mail]

  def send_contact_mail
    if @message.valid?
      Mailer.contact_mail(@message).deliver_now
      Mailer.contact_mail_copy_for_sender(@message).deliver_now
      redirect_to root_path, notice: t('mailer.orga_mail.success')
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
      flash[:alert] = t('mailer.orga_mail.captcha_failed')
      redirect_to contact_path
    end
  end

end
