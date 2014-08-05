require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Books' do

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.build(:user) }
  let(:book) { FactoryGirl.build(:book) }

  # before(:each) do
  #   # DatabaseCleaner.clean_with(:truncation)
  # #   visit new_user_session_path
  # #   fill_in "Email", with: user.email
  # #   fill_in "Password", with: user.password
  # #   click_button "Sign in"
  #   # @user = FactoryGirl.build(:user)
  # end

  describe 'New book' do
    describe 'with valid credentials' do
      it 'creates a new book' do
        visit new_book_path
        fill_in 'Title', with: book.title
        fill_in 'Isbn 10', with: book.isbn_10
        fill_in 'Isbn 13', with: book.isbn_13
        fill_in 'Author last', with: book.author_last
        fill_in 'Author first', with: book.author_first
        # click_button 'Save'
        # puts page.body.inspect
        expect { click_button 'Save' } .to change { Book.count }.by(1)
      end
    end
    describe 'with invalid credentials' do
      it 'displays the errors' do
        visit new_book_path
        click_button 'Save'
        expect(page).to have_text("errors prohibited")
      end
    end
  end
end
