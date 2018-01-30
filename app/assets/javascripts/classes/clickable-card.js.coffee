class @ClickableCard

  constructor: (html) ->
    html.click ->
      window.location = html.data("href");
      false