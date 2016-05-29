class @Likebox

  constructor: (@html) ->
    @page = @html.data('fb-page')
    @token = @html.data('fb-token')
    @likes = undefined
    @updateLikes(@showLikes)

  updateLikes: (callback) ->
    $.getJSON('https://graph.facebook.com/' + @page + '?access_token=' + @token, (res) =>
      @likes = res.likes
      callback() if callback?
    ).fail (jqxhr, textStatus, error) ->
      console.log 'Request Failed: ' + textStatus + ', ' + error
      console.log jqxhr.responseJSON
      @html.parent().hide()

  showLikes: =>
    @html.text @likes