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

Book.delete_all
book = Book.new(title: 'Convergence', isbn_10: '0671877747', isbn_13: '978-0671877743', author_last: 'Sheffield', author_first: 'Charles', user: User.first)
book.save
book = Book.new(title: 'Resurgence', isbn_10: '0743488199', isbn_13: '978-0743488198', author_last: 'Sheffield', author_first: 'Charles', user: User.first)
book.save

Rating.delete_all
rating = Rating.new(score: 5, user: User.first, book: Book.first)
rating.save
rating = Rating.new(score: 5, user: User.first, book: Book.last)
rating.save
rating = Rating.new(score: 4, user: User.last, book: Book.first)
rating.save
rating = Rating.new(score: 3, user: User.last, book: Book.last)
rating.save

Review.delete_all
review = Review.new(body: 'This book is great.', user: User.first, book: Book.first)
review.save
review = Review.new(body: 'This book is also great.', user: User.first, book: Book.last)
review.save
review = Review.new(body: 'This book is terrible.', user: User.last, book: Book.first)
review.save
review = Review.new(body: 'This book is also terrible.', user: User.last, book: Book.last)
review.save