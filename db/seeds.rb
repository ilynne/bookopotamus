# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
user = User.new(email: 'ilynne@gmail.com', password: 'secretsecret', password_confirmation: 'secretsecret')
user.save
user = User.new(email: 'lynne@ilynne.com', password: 'secretsecret', password_confirmation: 'secretsecret')
user.save

Book.delete_all
book = Book.new(title: 'Convergence', isbn_10: '0671877747', isbn_13: '978-0671877743', author_last: 'Sheffield', author_first: 'Charles', user: User.first)
book.save

Rating.delete_all
rating = Rating.new(score: 5, user: User.first, book: book)
rating.save
rating = Rating.new(score: 4, user: User.last, book: book)
rating.save