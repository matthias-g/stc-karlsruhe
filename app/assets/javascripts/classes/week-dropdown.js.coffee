# align week select dropdown
class @WeekDropdown

  constructor: (html) ->
    button = $(".dropdown-toggle", html)
    menu = $(".dropdown-menu", html)
    pos = button.position()
    width = menu.width()
    menu.css
      top: pos.top - 16 - 56 * menu.data("current")
      left: pos.left - width + 8