class GalleriesController < ApplicationController
  before_action :set_gallery, only: [:show, :edit, :update, :destroy, :make_all_visible, :make_all_invisible]
  before_action :authenticate_admin_user!, except: [:update]
  before_action :authenticate_user!, only: [:update]
  before_action :check_if_user_can_upload, only: [:update]

  respond_to :html

  def index
    @galleries = Gallery.all
    respond_with(@galleries)
  end

  def show
    @gallery_pictures = @gallery.gallery_pictures
    if @gallery_pictures.count == 0
      @gallery.gallery_pictures.build
    end
    respond_with(@gallery)
  end

  def new
    @gallery = Gallery.new
    @gallery.gallery_pictures.build
    respond_with(@gallery)
  end

  def edit
  end

  def create
    @gallery = Gallery.new(gallery_params)
    upload_pictures if @gallery.save
    respond_with(@gallery)
  end

  def update
    upload_pictures if @gallery.update(gallery_params)
    return redirect_to request.referer if request.referer
    respond_with(@gallery)
  end

  def destroy
    @gallery.destroy
    respond_with(@gallery)
  end

  def make_all_visible
    GalleryPicture.where(gallery_id: @gallery.id).update_all(visible: true)
    return redirect_to request.referer if request.referer
    redirect_to @gallery
  end

  def make_all_invisible
    GalleryPicture.where(gallery_id: @gallery.id).update_all(visible: false)
    return redirect_to request.referer if request.referer
    redirect_to @gallery
  end


  private

  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

  def gallery_params
    params.require(:gallery).permit(:title, gallery_pictures_attributes: [:id, :gallery_id, :picture])
  end

  def check_if_user_can_upload
    not_found unless current_user
    @gallery.projects.each do |project|
      not_found unless project.has_leader?(current_user) || project.has_volunteer?(current_user) || current_user.is_admin? || current_user.is_photographer?
    end
  end

  def upload_pictures
    if params[:gallery_pictures] && params[:gallery_pictures][:picture].size > 0
      params[:gallery_pictures][:picture].each do |picture|
        @gallery.gallery_pictures.create!(picture: picture, gallery: @gallery, uploader: current_user, visible: false)
      end
      flash[:notice] = t('project.message.galleryPicturesUploaded')
      send_notice_mail
    end
  end

  def send_notice_mail
    title = @gallery.title
    title = @gallery.projects.collect{ |p| p.title }.join(', ') if title.blank?
    message = Message.new(sender: 'no-reply@servethecity-karlsruhe.de',
                          subject: t('project.message.mailNewPictures.subject', pictureCount: params[:gallery_pictures][:picture].size),
                          recipient: StcKarlsruhe::Application::NOTIFICATION_RECIPIENT,
                          body: t('project.message.mailNewPictures.body',
                                  title: title,
                                  pictureCount: params[:gallery_pictures][:picture].size,
                                  uploader: current_user.first_name + '' + current_user.last_name))
    Mailer.generic_mail(message).deliver
  end
end