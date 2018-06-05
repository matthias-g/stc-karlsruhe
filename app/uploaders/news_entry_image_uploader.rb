
class NewsEntryImageUploader < BaseImageUploader

  # thumbnail, used in news lists
  version :thumb do
    process :crop
    process resize_to_fill: [120, 120]
  end

  # large version, used in the news entry show view
  version :large do
    process :crop
    process resize_to_fill: [300, 250]
  end

  # very large version, used in the news entry image lightbox
  version :fullscreen do
    process :crop
    process resize_to_fill: [800, 600]
  end

end
