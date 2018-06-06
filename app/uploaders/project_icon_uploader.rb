
class ProjectIconUploader < BaseImageUploader

  version :thumb do
    process resize_to_limit: [80, 80]
  end

end
