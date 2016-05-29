addRemoveLinks = (scope) ->
  scope.find('.remove-link').click ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.question-fields').hide()
    
addLink = ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_question", "g")
  question = $('#question-prototype').html().replace(regexp, new_id)
  $($(this).data('target')).before(question)
  console.log($('.questions').find('.question-fields').last())
  addRemoveLinks($('.questions').find('.question-fields').last())

  
onPageLoad ->
  addRemoveLinks($('.questions').find('.question-fields'))
  $('.add-link').click addLink

  $('#question-prototype').closest('form').submit ->
    $('#question-prototype').remove()

  # automatically set question position according to real position
  $('.template form').submit (e) ->
    $('.questions .position-field').each (idx) ->
      $(this).val(idx)

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