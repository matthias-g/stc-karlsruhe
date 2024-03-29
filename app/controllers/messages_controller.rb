class MessagesController < ApplicationController
  before_action :set_message, only: [:send_contact_mail]
  before_action :block_spam, only: [:send_contact_mail]

  def send_contact_mail
    if @message.valid?
      Mailer.contact_orga_mail(@message.body, @message.subject, @message.sender, current_user).deliver_later
      Mailer.contact_orga_mail_copy_for_sender(@message.body, @message.subject, @message.sender).deliver_later
      redirect_to root_path, notice: t('mailer.contact_orga_mail.success')
    else
      flash[:alert] = @message.errors.full_messages
      redirect_to_contact_form
    end
  end

  private

  def set_message
    @message = Message.new(params[:message])
  end

  def block_spam
    unless user_signed_in? || (verify_recaptcha(model: @message) && @message.simple_spam_check&.strip&.downcase == "karlsruhe")
      flash[:alert] = t('mailer.contact_orga_mail.captcha_failed')
      redirect_to_contact_form
    end
  end

  def redirect_to_contact_form
    session[:message] = params[:message]
    redirect_to contact_path
  end

end
