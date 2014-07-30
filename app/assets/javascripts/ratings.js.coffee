jQuery ->
  $("#star").raty
    readOnly: true
    start: 3.5
    path: "/assets"

  $("#user_star").raty
    score: 3
    path: "/assets"
    click: (score, evt) ->
      $.ajax
        url: "/ratings/" + 1
        type: "PATCH"
        data:
          score: score

      return