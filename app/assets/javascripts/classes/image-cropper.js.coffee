class ImageCropper
  constructor: (box) ->
    @box = box
    @img = $('img', @box)
    @img.Jcrop
      aspectRatio: @img.data('aspect')
      setSelect: [0, 0, 500, 500]
      onSelect: @update
      onChange: @update
  update: (coords) =>
    $('.crop_x', @box).val(coords.x)
    $('.crop_y', @box).val(coords.y)
    $('.crop_w', @box).val(coords.w)
    $('.crop_h', @box).val(coords.h)