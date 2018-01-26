changeVisibility = (visible, entryId) ->
  data = {
    'data': {
      'type': 'news_entries',
      'id': entryId,
      'attributes': {
        visible: visible
      }
    }
  }
  window.updateJsonApi("/api/news-entries/#{entryId}", data).done ->
    location.reload()

onPageLoad ->
  $('#news-entry-visibility-button').click ->
    button = $(@)
    changeVisibility(!button.data('visible'), button.data('entry-id'))