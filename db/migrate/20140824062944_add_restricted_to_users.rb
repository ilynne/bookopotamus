class AddRestrictedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :restricted, :boolean, :default => false
  end
end
