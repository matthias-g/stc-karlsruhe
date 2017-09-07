class PagesController < ApplicationController
  respond_to :html

  def home
    @partial_name = 'home'
    @next_project_week = ProjectWeek.all.sort_by{|week| week.days.first&.date || Date.new(2005) }.last
    render 'page'
  end

  def page
    @partial_name = params[:page].gsub('-', '')
    authorize :page, @partial_name if restricted_partials.include?(@partial_name)
    lookup_context.find_all("pages/_#{@partial_name}").any? or not_found
  end

  def own_project
    @message = Message.new
    @partial_name = 'eigenesprojekt'
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
