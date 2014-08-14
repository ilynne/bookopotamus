class RatingsController < ApplicationController
  before_filter only: [:new] do
    redirect_to :new_user_session unless current_user
  end

  def index
  end

  # GET /books/id/ratings/new
  def new
    @book = Book.find(params[:id])
    @rating = @book.ratings.find_or_create(user: current_user, score: params[:score], book: @book)
    @rating.save
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rating_params
    params[:rating].permit(:score, :book_id, :user_id,)
  end
end
