$ ->
  $('.restricted').click ->
    $.ajax
      type: $(this).data('method')
      url: $(this).data('url') + '/' + $(this).data('user-id')
      dataType: 'json'
      data:
        user:
          restricted: $(this).is(':checked')
$ ->
  $('.admin').click ->
    $.ajax
      type: $(this).data('method')
      url: $(this).data('url') + '/' + $(this).data('user-id')
      dataType: 'json'
      data:
        user:
          admin: $(this).is(':checked')