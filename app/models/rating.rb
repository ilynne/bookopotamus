class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  after_save :update_review

  def update_review
    review = Review.where('book_id = ? AND user_id = ?', self.book_id, self.user_id).first
    if review.present?
      review.score = score
      review.save
    end
  end
end
