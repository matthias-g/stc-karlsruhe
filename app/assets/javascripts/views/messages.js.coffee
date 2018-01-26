onPageLoad ->
  # disables attachments in trix editor
  $('#messages.contact-mail-form trix-editor').on "trix-file-accept", (event) ->
    event.preventDefault()
  $('#messages.contact-mail-form trix-editor').attr 'tabindex', 10