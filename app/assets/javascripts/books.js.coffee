# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.approved').click ->
    $.ajax
      type: $(this).data('method')
      url: $(this).data('url') + '/' + $(this).data('book-id')
      data:
        approved: $(this).is(':checked')

