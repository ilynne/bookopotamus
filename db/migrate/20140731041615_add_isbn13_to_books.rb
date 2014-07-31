class AddIsbn13ToBooks < ActiveRecord::Migration
  def change
    rename_column :books, :isbn, :isbn_10
    add_column :books, :isbn_13, :string
  end
end
