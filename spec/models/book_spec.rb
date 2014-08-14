require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book) }
  let(:rating) { FactoryGirl.create(:rating) }

  describe 'user_rating' do
    it 'should return 0 if there is no rating' do
      expect(book.user_rating(book.user)).to eq(0)
    end
    it 'should return a score between 1-5' do
      rated_book = rating.book
      rated_by = rating.user
      rated_book.user_rating(rated_by).should be_between(1, 5)
    end
  end

  describe 'approvable' do
    it 'should be false if the book has no cover image' do
      expect(book.approvable?).to eq(false)
    end
  end

  describe 'average rating' do
    it 'should return the average of ratings' do
      rated_book = book
      users = []
      2.times do
        users.push FactoryGirl.create(:user)
      end
      users.each do |u|
        FactoryGirl.create(:rating, user: u, book: rated_book, score: (1..5).to_a.sample)
      end
      ratings = rated_book.ratings.all
      average = ratings.sum(:score).to_f / ratings.size.to_f
      expect(rated_book.average_rating).to eq(average)
    end
  end
end
