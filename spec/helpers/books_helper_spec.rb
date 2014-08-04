require 'spec_helper'

describe BooksHelper do
  include BooksHelper
  let(:book) { FactoryGirl.create(:book) }

  describe 'author_last_first' do
    it 'returns the book author last, first' do
      expect(author_last_first(book)).to eq("#{book.author_last}, #{book.author_first}")
    end
  end

end
