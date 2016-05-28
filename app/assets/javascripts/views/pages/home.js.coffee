$ ->
  new Countdown($('#countdown'))

  $('.bigheader .logo').on 'contextmenu', ->
    $('#messages').append """
      <div class="alert alert-info alert-dismissible" role="alert">
        <a href="#" data-dismiss="alert" class="close">×</a>
        <ul><li>Möchtest Du unser Logo herunterladen? Auf unserer <a href="/presse">Presseseite</a> findest
        Du dafür ein <a href="/downloads/Logos.zip">Archiv</a> mit einer Auswahl verschiedener Versionen. </li></ul>
      </div>
    """
    true