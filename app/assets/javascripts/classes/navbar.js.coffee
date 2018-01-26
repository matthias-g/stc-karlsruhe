
class @Navbar

  constructor: (nav) ->

    $('a', nav).attr(tabindex: -1)
    nav.css(display: "block")

    $("[href='#nav']").click (e) ->
      e.preventDefault();
      nav.addClass("open");
      $('a', nav).removeAttr('tabindex')

    $("#nav-eclipse, a", nav).click ->
      nav.removeClass("open")
      $('a', nav).attr(tabindex: -1)