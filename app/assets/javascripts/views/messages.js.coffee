$ ->
  # disables attachments in trix editor
  $('.contact-form trix-editor').on "trix-file-accept", (event) ->
    event.preventDefault()

  $('.contact-form form').on "submit", (event) ->
    subject = $(this).find('#message_subject').val()
    message = $(this).find('#message_body_trix_input_message').val()
    if (!subject)
      createFlashMessage('Betreff darf nicht leer sein!', 'warning')
      event.preventDefault()
    else if (!message)
      createFlashMessage('Nachricht darf nicht leer sein!', 'warning')
      event.preventDefault()