# A Bootstrap card which is clickable while possibly containing nested hyperlinks.
# - Expects argument "data-href". Only URLs are allowed.

class @ClickableCard

  constructor: (html) ->
    html.click ->
      window.location = html.data("href");
      false