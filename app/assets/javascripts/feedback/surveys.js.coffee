$ ->
  addRemoveLinks = (scope) ->
    scope.find('.remove-link').click ->
      $(this).prev('input[type=hidden]').attr('value', 1)
      $(this).closest('.question-fields').hide()
  addRemoveLinks($('.question-fields'))

  $('.add-link').click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_question", "g")
    question = $('#question-prototype').html().replace(regexp, new_id)
    $($(this).data('target')).before(question)
    addRemoveLinks($('.question-fields').last())

  $('#question-prototype').closest('form').submit ->
    $('#question-prototype').remove()
