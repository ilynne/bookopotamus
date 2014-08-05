require 'spec_helper'

describe BooksController do
  DatabaseCleaner.clean_with(:truncation)
  let(:book) { FactoryGirl.create(:book) }

  before(:all) do
  end

  describe 'GET#index' do
    # render_views

    it "assigns all books as @books" do
      get :index, {}
      assigns(:books).should eq([book])
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested book' do
      book.save
      expect{delete :destroy, id: book.to_param}.to change{Book.count}.by(-1)
    end

    it 'redirects to the books list' do
      book.save
      delete :destroy, id: book.to_param
      response.should redirect_to(books_url)
    end
  end

end
