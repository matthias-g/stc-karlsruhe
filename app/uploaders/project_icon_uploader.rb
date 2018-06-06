
class ProjectIconUploader < BaseImageUploader

  version :thumb do
    process resize_to_limit: [80, 80]
  end

  version :medium do
    process resize_to_limit: [200, 200]
  end

end
