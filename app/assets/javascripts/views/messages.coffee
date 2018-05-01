onViewLoad 'messages->contact_mail_form', ->
  # disable attachments in trix editor
  $('trix-editor').attr(tabindex: 10).on("trix-file-accept", (e) -> e.preventDefault())