require 'spec_helper'

describe Rating do
  let(:rating) { FactoryGirl.create(:rating) }

  describe 'saving a rating' do
    it 'should update an existing review' do
      book = FactoryGirl.create(:book)
      review = FactoryGirl.create(:review, user: book.user, book: book)
      rating = FactoryGirl.create(:rating, user: book.user, score: 5, book: book )
      rating.save
      review.reload
      expect(review.score).to eq(rating.score)
    end
  end
end