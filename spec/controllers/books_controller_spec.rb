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

end
