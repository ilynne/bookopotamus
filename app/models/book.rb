class Book < ActiveRecord::Base
  has_many :ratings
  has_many :reviews
  belongs_to :user

  validates :title, presence: true
  validates :isbn_10, presence: true, length: { is: 10 }
  validates :isbn_13, presence: true, length: { is: 14 }
  validates :author_last, presence: true
  validates :author_first, presence: true

  accepts_nested_attributes_for :reviews, reject_if: proc { |attributes| attributes['body'].blank? }
  accepts_nested_attributes_for :ratings, reject_if: proc { |attributes| attributes['score'].blank? }

  # default_scope { where(approved: true) }

  scope :approved, -> { where(approved: true) }

  def average_rating
    ratings.sum(:score).to_f / ratings.size.to_f
  end

  def user_rating(user)
    rating = ratings.find_by_user_id(user)
    rating.present? ? rating : Rating.new
  end
end
