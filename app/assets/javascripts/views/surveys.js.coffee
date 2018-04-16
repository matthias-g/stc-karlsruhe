onViewLoad 'surveys', ->

  # add "remove question" buttons to all questions
  $('.questions').click '.remove-link', ->
    $(@).prev('input[type=hidden]').attr('value', 1)
    $(@).closest('.question-fields').hide()

  # enable "add question" button
  $('.add-link').click ->
    prototype_id = $(@).data('prototype')
    new_id = new Date().getTime()
    question = $($(prototype_id).html().replace(/new_item/g, new_id))
    $($(@).data('target')).before(question)
    registerContent(question)

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
    choice = $(@)
    text = $('<input type="text">').val(if (choice.val() == 'other') then '' else choice.val())
    text.on 'change keydown paste input select click', ->
      choice.val(text.val())
      choice.prop({checked: true})
    choice.parent().after(text)
