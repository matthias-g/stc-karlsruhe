class NewsEntryImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include Croppable

  storage :file

  version :thumb do
    process :crop_pic
    process :resize_to_fill => [120, 120]
  end

  version :article do
    process :crop_pic
    process :resize_to_fill => [300, 250]
  end

  version :fullscreen do
    process :crop_pic
    process :resize_to_fill => [800, 600]
  end


  version :precrop do
    process :resize_to_limit => [500, 500]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
