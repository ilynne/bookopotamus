class Book < ActiveRecord::Base

  has_many :ratings
  belongs_to :user

  def average_rating
    ratings.sum(:score).to_f / ratings.size.to_f
  end

  def rating(user = User.first)
    ratings.where(user: user).score
  end

end
