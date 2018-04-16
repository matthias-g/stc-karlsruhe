onViewLoad 'news_entries', ->

  # enable the "set news visiblity" button
  $('#news-entry-visibility-button').click ->
    visible = $(@).data('visible')
    entryId = $(@).data('entry-id')
    data = {data: {type: 'news_entries', id: entryId, attributes: {visible: !visible}}}
    window.updateJsonApi("/api/news-entries/#{entryId}", data).done ->
      location.reload()