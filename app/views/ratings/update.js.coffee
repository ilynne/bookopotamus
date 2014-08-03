$("#rating_book_<%= @book.id %>").empty();
$("#rating_book_<%= @book.id %>").raty({
  readOnly: true,
  start: <%= @book.average_rating %>,
  path: '/assets'
});