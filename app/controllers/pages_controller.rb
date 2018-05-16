class PagesController < ApplicationController
  respond_to :html

  def home
    @partial_name = 'home'
    render 'page'
  end

  def page
    @partial_name = params[:page].gsub('-', '')
    return home if @partial_name == 'home'
    return own_action if @partial_name == 'eigenesprojekt'
    return contact if @partial_name == 'contact'
    authorize :page, @partial_name if restricted_partials.include?(@partial_name)
    lookup_context.find_all("pages/_#{@partial_name}").any? or not_found
  end

  def own_action
    @message = Message.new
    @partial_name = 'eigenesprojekt'
    render 'page'
  end

  def contact
    @message = Message.new
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

end
