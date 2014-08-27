class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_one :rating, through: :user, source: :ratings

  validates :body, presence: true
end
