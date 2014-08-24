require 'spec_helper'

describe BooksController do
  DatabaseCleaner.clean_with(:truncation)
  # login_admin
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  # let(:authed_user) { create_logged_in_user }

  describe 'finding books' do
    it 'should find a book by text' do
      saved_book = FactoryGirl.create(:book, approved: true)
      saved_book.save
      get :index, search: 'book'
      assigns(:books).should eq([saved_book])
    end
    it 'should find a book by rating' do
      saved_book = FactoryGirl.create(:book, approved: true)
      rating = FactoryGirl.create(:rating, book: saved_book, score: 4)
      rating.save
      saved_book.save
      get :index, search: 4
      assigns(:books).should eq([saved_book])
    end
  end

  describe 'logged in as admin' do
    login_admin
    describe 'GET#index' do
      # render_views
      it "assigns all books as @books" do
        get :index, {}
        assigns(:books).should eq([book])
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the books list' do
        book.save
        delete :destroy, id: book.to_param
        response.should redirect_to(books_url)
      end
      describe 'as the book owner' do
        describe 'a book with a review' do
          it 'should deactivate the book' do
            controller.request.env["devise.mapping"] = Devise.mappings[:user]
            user = FactoryGirl.create(:user)
            sign_in user
            book = FactoryGirl.create(:book, user: user, approved: true)
            review = FactoryGirl.create(:review, user: user, book: book, body: 'text')
            delete :destroy, id: book.to_param
            book.reload
            expect(book.active).to eq(false)
          end
        end
      end
    end
  end

  describe 'logged in as user' do
    login_user
    describe 'GET#index' do
      # render_views
      it "assigns all books as @books" do
        get :index, {}
        assigns(:books).should_not eq([book])
      end
    end
  end

end
