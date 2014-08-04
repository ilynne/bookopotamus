module BooksHelper
  def author_last_first(book)
    return "#{book.author_last}, #{book.author_first}"
  end
end
