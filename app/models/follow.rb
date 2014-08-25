class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  after_save :validate_selections

  private

  def validate_selections
    unless rating? || review?
      Follow.where('book_id = ? AND user_id = ?', book_id, user_id).delete_all
    end
  end

end
