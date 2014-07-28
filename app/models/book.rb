class Book < ActiveRecord::Base

  has_many :ratings
  belongs_to :user

end
