onPageLoad ->
  # add "remove question" buttons to all questions
  $('.questions').on('click', '.remove-link', ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.question-fields').hide())

  # enable "add question" button and "add event" in actions/_form
  $('.add-link').click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_item", "g")
    question = $($(this).data('prototype')).html().replace(regexp, new_id)
    question = $(question)
    $($(this).data('target')).before(question)

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
