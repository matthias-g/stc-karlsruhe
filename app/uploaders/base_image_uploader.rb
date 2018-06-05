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
      resize_to_limit(500, 500)
      manipulate! do |img|
        x = model.crop_x
        y = model.crop_y
        w = model.crop_w
        h = model.crop_h
        img.crop "#{w}x#{h}+#{x}+#{y}"
        img
      end
    end
  end

end