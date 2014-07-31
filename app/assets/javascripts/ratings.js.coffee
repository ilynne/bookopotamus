jQuery ->
  $("#star").raty
    readOnly: true
    start: 3.5
    path: "/assets"

  $("#user_star").raty
    score: 5
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: "/ratings/" + 2
        type: "PATCH"
        data:
          score: score

      return