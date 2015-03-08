class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!, only: [:index, :new, :edit, :create, :update, :destroy]

  respond_to :html

  def index
    @pages = Page.all
    respond_with(@pages)
  end

  def show
    respond_with(@page)
  end

  def welcome
    @partial_name = 'welcome'
    render 'page'
  end

  def new
    @page = Page.new
    respond_with(@page)
  end

  def edit
    respond_with(@page)
  end

  def create
    @page = Page.new(page_params)
    @page.save
    respond_with(@page)
  end

  def update
    @page.update(page_params)
    respond_with(@page)
  end

  def destroy
    @page.destroy
    respond_with(@page)
  end

  def page
    @partial_name = params[:page].gsub('-', '')
    File.exists?(Rails.root.join('app', 'views', 'pages', "_#{@partial_name}.html.erb")) or not_found
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, { :section_ids => [] }, :header_name, :address)
    end

end
