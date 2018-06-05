
class InitiativePictureUploader < BaseImageUploader

  # thumbnail, used by the "_entry" partials and the "register_for_participation" view
  version :thumb do
    process :crop
    process resize_to_fill: [75, 60]
  end

  # medium version, used by the card-style action overview
  version :card do
    process :crop
    process resize_to_fill: [318, 220]
  end

  # large version, used by the action/project show views
  version :large do
    process :crop
    process resize_to_fill: [775, 350]
  end

end
