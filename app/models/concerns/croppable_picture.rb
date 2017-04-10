module CroppablePicture extend ActiveSupport::Concern

  included do
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    def crop_picture(x,y,w,h,version)
      self.crop_x = x
      self.crop_y = y
      self.crop_w = w
      self.crop_h = h
      picture.recreate_versions!(version)
    end

    def show_picture?
      !picture_source.blank? && picture&.file
    end
  end

end