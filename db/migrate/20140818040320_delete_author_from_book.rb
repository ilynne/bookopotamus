class DeleteAuthorFromBook < ActiveRecord::Migration
  def change
    remove_column :books, :author_first
    remove_column :books, :author_last
  end
end
