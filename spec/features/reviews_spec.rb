require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Reviews' do

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:review) { FactoryGirl.create(:review) }
  let(:rating) { FactoryGirl.create(:rating) }

  # before(:each) do
  #   DatabaseCleaner.clean_with(:truncation)
  #   visit new_user_session_path
  #   fill_in "Email", with: user.email
  #   fill_in "Password", with: user.password
  #   click_button "Sign in"
  #   # @user = FactoryGirl.build(:user)
  # end

  describe 'Viewing reviews' do
    it 'should list all the reviews' do
      review.save
      rating.save
      visit reviews_path
      expect(page.body).to include(review.body)
    end
    it 'should show all the reviews for a book' do
      review.save
      rating.save
      visit book_reviews_path(review.book.id)
      expect(page.body).to include(review.body)
    end
  end

end
