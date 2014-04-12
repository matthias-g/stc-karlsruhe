class ContactFormController < ApplicationController
  def index
  end

  def create
    ContactFormMailer.contact(params[:subject], params[:message], params[:email]).deliver
    redirect_to root_path, notice: t('contact.success')
  end

end
