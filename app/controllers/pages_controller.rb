class PagesController < ApplicationController
  respond_to :html

  before_action :set_message, only: [:contact, :own_action]

  def home
    @partial_name = 'home'
    render 'page'
  end

  def page
    @partial_name = params[:page].gsub('-', '')
    return home if @partial_name == 'home'
    if @partial_name == 'eigenesprojekt'
      set_message
      return own_action
    end
    if @partial_name == 'contact'
      set_message
      return contact
    end
    authorize :page, @partial_name if restricted_partials.include?(@partial_name)
    lookup_context.find_all("pages/_#{@partial_name}").any? or not_found
  end

  def own_action
    @partial_name = 'eigenesprojekt'
    render 'page'
  end

  def contact
    @partial_name = 'contact'
    render 'page'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.require(:page)
  end

  def restricted_partials
    ['admindashboard']
  end

  def set_message
    if session[:message]
      @message = Message.new(session[:message])
      session[:message] = nil
    else
      @message = Message.new
    end
  end

end
