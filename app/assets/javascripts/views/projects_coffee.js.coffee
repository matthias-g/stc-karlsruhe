jQuery ->
  new ImageCropper()
  $('.modal').on 'shown.bs.modal': ->
    new ImageCropper()

class ImageCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: $('#cropbox').data('aspect')
      setSelect: [0, 0, 500, 500]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#crop_x').val(coords.x)
    $('#crop_y').val(coords.y)
    $('#crop_w').val(coords.w)
    $('#crop_h').val(coords.h)