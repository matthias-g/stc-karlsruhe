onPageLoad ->

  $('.bigheader .logo').on 'contextmenu', ->
    createFlashMessage('Möchtest Du unser Logo herunterladen? Auf unserer <a href="/presse">Presseseite</a> findest
        Du dafür ein <a href="/downloads/Logos.zip">Archiv</a> mit einer Auswahl verschiedener Versionen.')
    true