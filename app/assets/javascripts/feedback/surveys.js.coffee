# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.remove-link').click ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.question-fields').hide()
  $('.add-link').click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_question", "g")
    $(this).parent().before($('#question-prototype').html().replace(regexp, new_id))
  $('#question-prototype').closest('form').submit ->
    $('#question-prototype').remove()