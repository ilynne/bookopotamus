class AddAuthorToBooks < ActiveRecord::Migration
  def change
    add_column :books, :author_last, :string
    add_column :books, :author_first, :string
  end
end
