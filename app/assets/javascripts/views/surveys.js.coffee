onPageLoad ->
  # add "remove question" buttons to all questions
  addRemoveLinks $('.questions').find('.question-fields')

  # enable "add question" button
  $('.add-link').click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_question", "g")
    question = $('#question-prototype').html().replace(regexp, new_id)
    question = $(question)
    $($(this).data('target')).before(question)
    addRemoveLinks question

  # don't submit the question prototype
  $('#question-prototype').closest('form').submit ->
    $('#question-prototype').remove()

  # automatically set question position according to real position
  $('.template form').submit (e) ->
    $('.questions .position-field').each (idx) ->
      $(@).val(idx)

  # make questions in the template sortable
  $('.template .questions').sortable()

  # create free text option for multiple choice groups
  $('.text-choice').each ->
    choice = $(this)
    text = $('<input type="text">').val(if (choice.val() == 'other') then '' else choice.val())
    text.on 'change keydown paste input select click', ->
      choice.val(text.val())
      choice.prop({checked: true})
    choice.parent().after(text)


# Enables all "remove question" links in the given HTML
addRemoveLinks = (scope) ->
  scope.find('.remove-link').click ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.question-fields').hide()