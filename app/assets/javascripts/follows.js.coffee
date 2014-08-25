$ ->
  $('.followed').click ->
    $.ajax
      type: $(this).data('method')
      url: $(this).data('url')
      dataType: 'json'
      data:
        follow:
          rating: $(this).is(':checked')
          review: $(this).is(':checked')
          book_id: $(this).data('book-id')
          user_id: $(this).data('user-id')
