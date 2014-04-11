class ContactUserController < ApplicationController
  def index
  end

  def create
    ContactFormMailer.contact(params[:user], params[:subject], params[:content], params[:email]).deliver
  end

end
