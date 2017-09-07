onPageLoad ->
  parentTopPadding = parseInt($("#weekDropdownMenu").parent().parent().css('padding-top').slice(0, -2))
  $("#weekDropdownMenu").css("top", 1 + parentTopPadding - 54.5 * $("#weekDropdownMenu").attr("data-current"))