require 'spec_helper'

describe Notification do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }

  describe 'a rating email' do
    it 'should email the follower' do
      options = {to: user.email, action: 'rated', subject: 'Bookopotamus Rating Notice'}
      Notification.book_reviewed(book, options).deliver
      delivery = ActionMailer::Base.deliveries.last
      expect(delivery.subject).to eq(options[:subject])
    end
  end
end