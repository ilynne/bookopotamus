class AddActiveToBook < ActiveRecord::Migration
  def change
    add_column :books, :active, :boolean, :default => true
  end
end
