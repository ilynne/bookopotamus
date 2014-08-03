jQuery ->
  $(".star").raty
    readOnly: true
    start: ->
      $(this).attr "data-score"
    path: "/assets"

jQuery ->
  $(".user_star").raty
    start: ->
      $(this).attr "data-score"
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: "/ratings/" + $(this).attr "data-rating-id"
        type: "PATCH"
        data:
          score: score
      return
