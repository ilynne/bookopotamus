# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
user = User.new(email: 'lynne@ilynne.com', password: 'secretsecret', password_confirmation: 'secretsecret', admin: true)
user.save
user = User.new(email: 'ilynne@gmail.com', password: 'secretsecret', password_confirmation: 'secretsecret')
user.save
15.times do |n|
  user = User.new(email: "example#{n}@example.com", password: "secret#{n}secret", password_confirmation: "secret#{n}secret")
  user.save
end

Author.delete_all
author = Author.new(last_name: 'Sheffield', first_name: 'Charles')
author.save
author = Author.new(last_name: 'Asimov', first_name: 'Isaac')
author.save
author = Author.new(last_name: 'Adams', first_name: 'Douglas')
author.save

Book.delete_all
book = Book.new(title: 'Convergence', isbn_10: '0671877747', isbn_13: '978-0671877743', author: Author.first, user: User.first, approved: [true, false].sample, cover: File.open(File.join(Rails.root, '/public/images/dontpanic.png')))
book.save
book = Book.new(title: 'Resurgence', isbn_10: '0743488199', isbn_13: '978-0743488198', author: Author.first, user: User.last, approved: [true, false].sample, cover: File.open(File.join(Rails.root, '/public/images/dontpanic.png')))
book.save
15.times do |n|
  isbn = 1000000000 + n
  book = Book.new(title: "Example Book Title #{n}", isbn_10: isbn, isbn_13: "123-#{isbn}", author: Author.all.sample, user: User.all.sample, approved: [true, false].sample, cover: File.open(File.join(Rails.root, '/public/images/dontpanic.png')))
  book.save
end

Rating.delete_all
rating = Rating.new(score: 5, user: User.first, book: Book.first)
rating.save
rating = Rating.new(score: 5, user: User.first, book: Book.last)
rating.save
rating = Rating.new(score: 4, user: User.last, book: Book.first)
rating.save
rating = Rating.new(score: 3, user: User.last, book: Book.last)
rating.save
Book.all.each do |b|
  User.first(15).each do |u|
    ratings = (1..5).to_a
    rating = Rating.create!(score: ratings.sample, user: u, book: b)
  end
  b.average_rating
end

Review.delete_all
review = Review.new(body: 'This book is great.', user: User.first, book: Book.first)
review.save
review = Review.new(body: 'This book is also great.', user: User.first, book: Book.last)
review.save
review = Review.new(body: 'This book is terrible.', user: User.last, book: Book.first)
review.save
review = Review.new(body: 'This book is also terrible.', user: User.last, book: Book.last)
review.save

Book.last(15).each do |b|
  User.first(15).each do |u|
    review_prefix = ['I thought this book was', 'This book is']
    reviews = [:great, :average, :terrible, :funny]
    review = Review.create!(body: "#{review_prefix.sample} #{reviews.sample}.", user: u, book: b)
  end
end

Follow.delete_all
Book.last(15).each do |b|
  User.first(3).each do |u|
    follow = Follow.create!(user: u, book: b, rating: [true, false].sample, review: true)
    follow.save
  end
end
