require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  let(:book) { FactoryGirl.create(:book) }

  describe 'book_status' do
    it 'returns the book author last, first' do
      expect(book_status(book)).to eq('Active')
    end
  end

end
