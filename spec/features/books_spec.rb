require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Books' do

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.build(:user) }
  let(:book) { FactoryGirl.build(:book) }
  let(:book) { FactoryGirl.build(:review) }

  # before(:each) do
  #   DatabaseCleaner.clean_with(:truncation)
  #   visit new_user_session_path
  #   fill_in "Email", with: user.email
  #   fill_in "Password", with: user.password
  #   click_button "Sign in"
  #   # @user = FactoryGirl.build(:user)
  # end

  describe 'Editing a book' do
    describe 'with valid parameters' do
      it 'should update the title' do
        book.save
        visit edit_book_path book.id
        fill_in 'Title', with: 'New Title'
        click_button 'Save'
        book.reload
        expect(book.title).to eq('New Title')
      end
    end
    describe 'with invalid parameters' do
      it 'should not update the isbn_10' do
        book.save
        visit edit_book_path book.id
        fill_in 'Isbn 10', with: '12345'
        click_button 'Save'
        expect(page).to have_text("prohibited this book")
      end
    end
  end

  describe 'New book' do
    describe 'with valid parameters' do
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
    describe 'with invalid parameters' do
      it 'displays the errors' do
        visit new_book_path
        click_button 'Save'
        expect(page).to have_text("prohibited this book")
      end
    end
    describe 'with a nested review' do
      it 'has a review text area' do
        visit new_book_path
        expect(page).to have_field('book_review_body')
      end
      it 'saves a review with the book' do
        visit new_book_path
        fill_in 'Title', with: book.title
        fill_in 'Isbn 10', with: book.isbn_10
        fill_in 'Isbn 13', with: book.isbn_13
        fill_in 'Author last', with: book.author_last
        fill_in 'Author first', with: book.author_first
        fill_in 'book_review_body', with: review_body
        puts Book.last.inspect
        puts Book.last.reviews.last.inspect
        click_button 'Save'
      end
    end
  end
end
