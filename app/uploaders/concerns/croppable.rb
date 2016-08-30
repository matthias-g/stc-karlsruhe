module Croppable extend ActiveSupport::Concern

  included do
    def crop_pic
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

end