class PagesController < ApplicationController
  respond_to :html

  def home
    @partial_name = 'home'
    render 'page'
  end

  def page
    @partial_name = params[:page].gsub('-', '')
    lookup_context.find_all("pages/_#{@partial_name}").any? or not_found
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page)
    end

end
