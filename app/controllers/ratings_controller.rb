class RatingsController < ApplicationController
  before_filter only: [:new] do
    redirect_to :new_user_session unless current_user
  end

  def index
  end

  # GET /books/id/ratings/new
  def new
    @book = Book.find(params[:book_id])
    @rating = Rating.find_or_create_by(user: current_user, book: @book)
    @rating.score = params[:score]
    respond_to do |format|
      if @rating.save
        format.json { head :no_content }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rating_params
    params[:rating].permit(:score, :book_id, :user_id,)
  end
end
