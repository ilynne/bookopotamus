require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Books' do
  DatabaseCleaner.clean_with(:truncation)

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.create(:user) }
  let(:author) { FactoryGirl.create(:author) }
  let(:book) { FactoryGirl.create(:book, user: user) }
  let(:review) { FactoryGirl.create(:review, book: book) }

  describe 'as an anonymous user' do
    it 'should not list any books' do
      visit books_path
      expect(page.body).to have_text('No books!')
    end
  end

  describe 'as a signed in user' do
    before(:each) do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end

    describe 'viewing books' do
      it 'should have an edit link' do
        book.save
        visit books_path
        expect(page.body).to have_link('Edit')
      end
      it 'should have a destroy link' do
        book.save
        visit books_path
        expect(page.body).to have_link('Destroy')
      end
      it 'should delete the book' do
        book.save
        visit books_path
        # click_link 'destroy'
        expect { click_link 'Destroy' } .to change { Book.count }.by(-1)
      end
    end
    describe 'Editing a book' do
      describe 'with valid parameters' do
        it 'should update the title' do
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
          fill_in 'book_author_attributes_last_first', with: "#{author.last_name}, #{author.first_name}"
          attach_file 'Cover', 'spec/fixtures/files/missing.png'
          expect { click_button 'Save' } .to change { Book.count }.by(1)
        end
        it 'creates a new author' do
          visit new_book_path
          fill_in 'Title', with: book.title
          fill_in 'Isbn 10', with: book.isbn_10
          fill_in 'Isbn 13', with: book.isbn_13
          fill_in 'book_author_attributes_last_first', with: 'Author, New'
          expect { click_button 'Save' } .to change { Author.count }.by(1)
        end
      end
      describe 'with invalid parameters' do
        it 'displays the errors' do
          visit new_book_path
          click_button 'Save'
          expect(page).to have_text('prohibited this book')
        end
      end
      describe 'with a nested review' do
        it 'has a review text area' do
          visit new_book_path
          expect(page).to have_field('book_reviews_attributes_0_body')
        end
        it 'saves a review with the book' do
          visit new_book_path
          fill_in 'Title', with: book.title
          fill_in 'Isbn 10', with: book.isbn_10
          fill_in 'Isbn 13', with: book.isbn_13
          fill_in 'book_author_attributes_last_first', with: "#{author.last_name}, #{author.first_name}"
          fill_in 'book_reviews_attributes_0_body', with: review.body
          click_button 'Save'
          expect(book.reviews.last.body).to eq(review.body)
        end
        describe 'editing inline reviews' do
          before(:each) do
            @user_book = FactoryGirl.create(:book, user: user)
            @user_review = FactoryGirl.create(:review, user: user, book: @user_book)
          end
          it 'updates a review' do
            visit book_path @user_book
            fill_in 'review_body', with: 'Great'
            click_button 'Update'
            @user_review.reload
            expect(@user_review.body).to eq('Great')
          end
          it 'rejects an empty review' do
            visit book_path @user_book
            fill_in 'review_body', with: ''
            click_button 'Update'
            @user_review.reload
            expect(page).to have_text('Error')
          end
        end
        describe 'adding inline reviews' do
          before(:each) do
            @user_book = FactoryGirl.create(:book, user: user)
          end
          it 'creates a new review' do
            visit book_path @user_book
            fill_in 'review_body', with: 'Great'
            expect { click_button 'Submit' } .to change { Review.count }.by(1)
            # expect(@user_review.body).to eq('Great')
          end
          it 'does not create an empty review' do
            visit book_path @user_book
            fill_in 'review_body', with: ''
            click_button 'Submit'
            expect(page).to have_text('Error')
          end
        end
      end
    end
  end
end
