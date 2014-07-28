class Book < ActiveRecord::Base

  has_many :ratings
  belongs_to :user

  def average_rating
    ratings.sum(:score) / ratings.size
  end

end
