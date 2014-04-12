class ContactUserController < ApplicationController
  def index
  end

  def create
    ContactFormMailer.contact(params[:user], params[:subject], params[:message], params[:email]).deliver
  end

end
