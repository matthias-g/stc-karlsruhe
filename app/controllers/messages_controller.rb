class MessagesController < ApplicationController
  before_action :set_message, only: [:send_contact_mail]
  before_action :block_spam, only: [:send_contact_mail]
  before_action :verify_privacy_consent, only: [:send_contact_mail]

  def send_contact_mail
    if @message.valid?
      Mailer.contact_orga_mail(@message.body, @message.sender, @message.subject).deliver_later
      Mailer.contact_orga_mail_copy_for_sender(@message.body, @message.sender, @message.subject).deliver_later
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
    unless user_signed_in? || verify_recaptcha(model: @message)
      flash[:alert] = t('mailer.contact_orga_mail.captcha_failed')
      redirect_to_contact_form
    end
  end

  def verify_privacy_consent
    unless (params[:message][:privacy_consent] == '1') || user_signed_in?
      flash[:alert] = t('mailer.contact_orga_mail.privacy_consent_missing')
      redirect_to_contact_form
    end
  end

  def redirect_to_contact_form
    session[:message] = params[:message]
    redirect_to contact_path
  end

end
