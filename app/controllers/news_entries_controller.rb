class NewsEntriesController < ApplicationController
  before_action :set_news_entry, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_news_entry,  except: [:index, :new, :create]
  after_action :verify_authorized,  except: [:index]

  respond_to :html

  def index
    @news_entries = policy_scope(NewsEntry).order(created_at: :desc)
  end

  def show
  end

  def new
    @news_entry = NewsEntry.new
    @news_entry.visible = false
    authorize_news_entry
  end

  def edit
  end

  def create
    @news_entry = NewsEntry.new(news_entry_params)
    authorize_news_entry
    if @news_entry.save
      flash[:notice] = t('news_entry.message.created')
    end
    respond_with @news_entry
  end

  def update
    if @news_entry.update(news_entry_params)
      flash[:notice] = t('news_entry.message.updated')
    end
    respond_with @news_entry
  end

  def destroy
    if @news_entry.destroy
      flash[:notice] = t('news_entry.message.deleted')
    end
    respond_with @news_entry
  end

  def crop_picture
    if params.has_key?(:crop_x)
      @news_entry.crop_picture(params[:crop_x].to_i, params[:crop_y].to_i,
                               params[:crop_w].to_i, params[:crop_h].to_i,
                               params[:crop_target].to_sym)
      redirect_to @news_entry, notice: t('news_entry.message.imageCropped')
    else
      @crop_target_symbol = params[:crop_target].to_sym
      case @crop_target_symbol
        when :article
          @crop_target_title = t('news_entry.label.articleImage')
          @crop_target_ratio = 300.0/250
        when :fullscreen
          @crop_target_title = t('news_entry.label.fullscreenImage')
          @crop_target_ratio = 800.0/600
        when :thumbnail
          @crop_target_title = t('news_entry.label.thumbnailImage')
          @crop_target_ratio = 120.0/120
      end
      respond_with @news_entry do |format|
        format.html { render :layout => false}
      end
    end
  end

  private
    def set_news_entry
      @news_entry = NewsEntry.friendly.find(params[:id])
    end

    def news_entry_params
      params.require(:news_entry).permit(:title, :teaser, :text, :picture, :picture_source, :category, :visible)
    end

    def authorize_news_entry
      authorize @news_entry
    end
end
