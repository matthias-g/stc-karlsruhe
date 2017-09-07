onPageLoad ->
  parentTopPadding = parseInt($("#weekDropdownMenu").parent().parent().css('padding-top').slice(0, -2))
  $("#weekDropdownMenu").css("top", 8 + parentTopPadding - 52.5 * $("#weekDropdownMenu").attr("data-current"))