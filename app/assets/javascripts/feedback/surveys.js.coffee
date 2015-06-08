$ ->

  $('.remove-link').click ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.question-fields').hide()

  $('.add-link').click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_question", "g")
    question = $('#question-prototype').html().replace(regexp, new_id)
    $($(this).data('target')).before(question)

  $('#question-prototype').closest('form').submit ->
    $('#question-prototype').remove()