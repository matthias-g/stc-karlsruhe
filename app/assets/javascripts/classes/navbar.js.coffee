# A navigation bar. Will be closed by default.

class @Navbar

  constructor: (@nav) ->
    # activate nav (previously hidden to prevent unstyled flashing)
    @close()
    @nav.css(display: 'block')

    # activate open nav links on the page
    $("[href='#nav']").click (e) =>
      e.preventDefault()
      @open()

    # clicking any nav link or the nav background will close the nav
    $("#nav-eclipse, a", nav).click =>
      @close()

  open: ->
    @nav.addClass('open').find('a').removeAttr('tabindex')

  close: ->
    @nav.removeClass('open').find('a').attr(tabindex: -1)