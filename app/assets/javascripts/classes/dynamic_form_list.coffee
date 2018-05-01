# Defines a section in which instances of a prototype item can be added or removed
# - the HTML must contain a prototype with an included remove link
# - the HTML must contain an add link

class @DynamicFormList

  constructor: (html) ->

    # extract item prototype
    prototype = $('.prototype', html).remove()
    prototype_html = prototype.html()

    # enable "remove" buttons on all items
    html.on 'click', '.remove-link', ->
      return if not $.rails.confirm I18n.t 'event.message.confirmDelete'
      $(@).prev('input[type=hidden]').attr('value', 1)
      $(@).closest('.item').hide()

    # enable "add" button
    add_link = $('.add-link', html)
    add_link.click ->
      new_item = $(prototype_html.replace(/new_item/g, new Date().getTime()))
      add_link.before(new_item)
      registerContent(new_item)