# A wrapper for the JCrop library
# - Expects to find nested tags: img, input.crop_x/y/w/h
# - Expects attribute "data-aspect"

class @Cropbox
  
  constructor: (@html) ->
    @img = $('img', @html)
    @img.Jcrop
      aspectRatio: @html.data('aspect')
      setSelect: [0, 0, 500, 500]
      onSelect: @update
      onChange: @update
      
  update: (coords) =>
    $('.crop_x', @html).val(coords.x / @img.width())
    $('.crop_y', @html).val(coords.y / @img.height())
    $('.crop_w', @html).val(coords.w / @img.width())
    $('.crop_h', @html).val(coords.h / @img.height())