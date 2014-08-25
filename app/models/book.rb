class Book < ActiveRecord::Base
  has_many :ratings
  has_many :reviews
  has_many :follows
  belongs_to :user
  belongs_to :author, :autosave => true
  mount_uploader :cover, CoverUploader

  validates :title, presence: true
  validates :isbn_10, presence: true, length: { is: 10 }
  validates :isbn_13, presence: true, length: { is: 14 }
  # validates :author_id, presence: true

  accepts_nested_attributes_for :reviews, reject_if: proc { |attributes| attributes['body'].blank? }
  accepts_nested_attributes_for :ratings, reject_if: proc { |attributes| attributes['score'].blank? }
  accepts_nested_attributes_for :author, reject_if: proc { |attributes| attributes['last_first'].blank? }
  accepts_nested_attributes_for :follows

  scope :approved, -> { where(approved: true) }

  def average_rating
    saved_rating.present? ? saved_rating : calculate_average_rating.to_f
  end

  def calculate_average_rating
    saved_rating = ratings.any? ? ratings.sum(:score).to_f / ratings.size : 0
    update_attribute(:saved_rating, saved_rating)
    saved_rating.to_f
  end

  def user_rating(user)
    rating = ratings.find_by_user_id(user)
    rating.present? ? rating.score : 0
  end

  def approvable?
    cover.present?
  end

  def autosave_associated_records_for_author
    if new_author = Author.find_by(last_name: author.last_name, first_name: author.first_name)
      self.author = new_author
    else
    #   # not quite sure why I need the part before the if,
    #   # but somehow the seat is losing its client_id value
      self.author = author if self.author.save!
    end
  end

  def followed_by_user?(user)
    follows.where(user_id: user).present?
  end

  def self.user_book_index(user)
    where("user_id = ? OR approved = ?", user.id, 1)
  end

  def user_review(user)
    reviews.find_by user_id: user.id
  end

  def deleteable?
    !reviews.any? && !ratings.any?
  end
end
