class Book < ActiveRecord::Base
  has_many :ratings
  belongs_to :user

  def average_rating
    ratings.sum(:score).to_f / ratings.size.to_f
  end

  def user_rating(user)
    rating = ratings.find_by_user_id(user)
    rating.present? ? rating : Rating.new
  end
end
