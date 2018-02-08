onPageLoad ->
  # enable the "set news visiblity" button
  $('#news-entry-visibility-button').click ->
    changeVisibility(!$(@).data('visible'), $(@).data('entry-id'))


# Sets the visiblity status for the given news entry
changeVisibility = (visible, entryId) ->
  data = 'data': {type: 'news_entries', id: entryId, attributes: {visible: visible}}
  window.updateJsonApi("/api/news-entries/#{entryId}", data).done ->
    location.reload()