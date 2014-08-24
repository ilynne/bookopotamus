class AddSavedRatingToBooks < ActiveRecord::Migration
  def change
    add_column :books, :saved_rating, :float
  end
end
