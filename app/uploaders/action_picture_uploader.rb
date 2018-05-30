# encoding: utf-8

class ActionPictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include Croppable
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # process :scale => [200, 300]
  # def scale(width, height)
  #   # do something
  # end


  version :action_list do
    process :crop_pic
    process resize_to_fill: [75, 60]
  end

  version :action_card_list do
    process :crop_pic
    process resize_to_fill: [318, 220]
  end

  version :action_view do
    process :crop_pic
    process resize_to_fill: [775, 350]
  end


  version :precrop do
    process resize_to_limit: [500, 500]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
