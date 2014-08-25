require 'spec_helper'

describe Follow do
  let(:follow) { FactoryGirl.create(:follow) }

  describe 'no rating or review attribute' do
    it 'should be deleted if review and rating are false' do
      follow.review = false
      follow.rating = false
      follow.save
      expect(Follow.exists?(follow)).to eq(false)
    end
  end
end