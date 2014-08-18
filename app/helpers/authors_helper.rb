module AuthorsHelper
  def author_last_first(author)
    return "#{author.last_name}, #{author.first_name}"
  end
end
