class AddEmailTimestampsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_rating_email, :datetime
    add_column :users, :last_review_email, :datetime
    add_column :users, :last_digest_email, :datetime
  end
end
