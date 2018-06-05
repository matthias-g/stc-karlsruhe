
class GalleryPictureUploader < BaseImageUploader

  process :auto_orient
  after :store, :store_dimensions

  # thumbnail, used in the gallery slider bottom row
  version :thumb do
    process resize_to_fill: [79, 53]
  end

  # medium version, used in the gallery slider
  version :large do
    process resize_to_limit: [524, 351]
  end

  # large version, used in the gallery lightbox
  version :fullscreen do
    process resize_to_limit: [1920, 1080]
  end


  private

  # rotates the image according to EXIF orientation
  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  # stores the image dimensions in GalleryPicture fields
  def store_dimensions(_params)
    if file && model
      width, height = ::MiniMagick::Image.open(file.file)[:dimensions]
      desktop_width, desktop_height = ::MiniMagick::Image.open(model.picture.fullscreen.file.file)[:dimensions]
      model.update(width: width, height: height, desktop_width: desktop_width, desktop_height: desktop_height)
    end
  end

end
