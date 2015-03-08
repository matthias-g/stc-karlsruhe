class PageSectionsController < ApplicationController
  before_action :set_page_section, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  respond_to :html

  def index
    @page_sections = PageSection.all
    respond_with(@page_sections)
  end

  def show
    respond_with(@page_section)
  end

  def new
    @page_section = PageSection.new
    if PageSection.count > 0
      @page_section.index = PageSection.order(index: :desc).first.index + 1
    else
      @page_section.index = 0
    end
    respond_with(@page_section)
  end

  def edit
    respond_with(@page_section)
  end

  def create
    @page_section = PageSection.new(page_section_params)
    @page_section.save
    respond_with(@page_section)
  end

  def update
    @page_section.update(page_section_params)
    respond_with(@page_section)
  end

  def destroy
    @page_section.destroy
    respond_with(@page_section)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_section
      @page_section = PageSection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_section_params
      params.require(:page_section).permit(:title, :content, :css_class, :partial_name, :index, :stylesheet)
    end
end
