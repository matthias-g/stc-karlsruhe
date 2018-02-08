onPageLoad ->
  # disable attachments in trix editor
  trix_editor = $('#messages.contact-mail-form trix-editor')
  trix_editor.attr(tabindex: 10).on("trix-file-accept", (e) -> e.preventDefault())