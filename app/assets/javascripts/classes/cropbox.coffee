# A wrapper for the JCrop library
# - Expects to find nested tags: img, input.crop_x/y/w/h
# - Expects attribute "data-aspect"

class @Cropbox
  
  constructor: (@html) ->
    $('img', @html).Jcrop
      aspectRatio: @html.data('aspect')
      setSelect: [0, 0, 500, 500]
      onSelect: @update
      onChange: @update
      
  update: (coords) =>
    $('.crop_x', @html).val(coords.x)
    $('.crop_y', @html).val(coords.y)
    $('.crop_w', @html).val(coords.w)
    $('.crop_h', @html).val(coords.h)