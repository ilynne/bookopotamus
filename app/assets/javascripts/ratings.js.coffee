jQuery ->
  $(".star").raty
    readOnly: true
    start: ->
      $(this).attr "data-score"
    path: "/assets"

jQuery ->
  $(".new_star").raty
    path: "/assets"

jQuery ->
  $(".user_star").raty
    start: ->
      $(this).attr "data-score"
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: $(this).attr "data-url"
        type: "GET"
        data:
          score: score
      return

