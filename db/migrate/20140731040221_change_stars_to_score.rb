class ChangeStarsToScore < ActiveRecord::Migration
  def change
    rename_column :ratings, :stars, :score
  end
end
