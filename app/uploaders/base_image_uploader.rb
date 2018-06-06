class BaseImageUploader  < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  storage :file

  # preview version for the cropping modal
  version :precrop do
    process resize_to_limit: [500, 500]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # will crop the version according to the values given in model.crop_x/y/w/h
  def crop
    if model.crop_x.present?
      real_w, real_h = ::MiniMagick::Image.open(model.picture.file.file)[:dimensions]
      manipulate! do |img|
        x = model.crop_x * real_w
        y = model.crop_y * real_h
        w = model.crop_w * real_w
        h = model.crop_h * real_h
        img.crop "#{w.to_i}x#{h.to_i}+#{x.to_i}+#{y.to_i}"
        img
      end
    end
  end

end