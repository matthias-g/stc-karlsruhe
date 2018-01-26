onPageLoad ->
  $('#page-supporters .nav-tabs a').click((e) ->
    e.preventDefault()
    $(this).tab('show')
  )