class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :review, presence: true
end
