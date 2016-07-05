$ ->
  # disables attachments in trix editor
  $('.contact-form trix-editor').on "trix-file-accept", (event) ->
    event.preventDefault()
  $('.contact-form trix-editor').attr 'tabindex', 10