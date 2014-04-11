class ContactFormController < ApplicationController
  def index
  end

  def create
    ContactFormMailer.contact(params[:subject], params[:content], params[:email]).deliver
  end

end
