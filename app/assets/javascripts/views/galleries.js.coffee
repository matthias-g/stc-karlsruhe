onPageLoad ->
  
  # auto submit uploaded images
  $('form.edit_gallery').each (i, f) ->
    $('#gallery_picture', f).change ->
      $('.waitinfo', f).show()
      $(f).submit()
    $('input[type="submit"]', f).css visibility: 'hidden'