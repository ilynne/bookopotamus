class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :body, presence: true
end
