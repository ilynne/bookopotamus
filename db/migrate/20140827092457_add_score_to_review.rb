class AddScoreToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :score, :integer, default: 0
  end
end
