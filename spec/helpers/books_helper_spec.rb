require 'spec_helper'

describe AuthorsHelper do
  include AuthorsHelper
  let(:book) { FactoryGirl.create(:book) }

  describe 'author_last_first' do
    it 'returns the book author last, first' do
      expect(author_last_first(book.author)).to eq("#{book.author.last_name}, #{book.author.first_name}")
    end
  end

end
