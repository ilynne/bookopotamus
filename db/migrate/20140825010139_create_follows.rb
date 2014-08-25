class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :book_id
      t.boolean :rating
      t.boolean :review

      t.timestamps
    end
  end
end
