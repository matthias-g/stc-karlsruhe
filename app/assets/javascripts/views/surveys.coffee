onViewLoad 'surveys', ->

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
