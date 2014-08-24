class RatingsController < ApplicationController
  before_filter only: [:new] do
    redirect_to :new_user_session unless current_user
  end

  def index
  end

  # GET /books/id/ratings/new
  def new
    @book = Book.find(params[:book_id])
    if @book.active
      @rating = Rating.find_or_create_by(user: current_user, book: @book)
      update_rating(@rating, @book)
    else
      render json: @book.average_rating, status: :created
    end
  end

  def update_rating(rating, book)
    rating.score = params[:score]
    respond_to do |format|
      if rating.save
        book.calculate_average_rating
        format.json { render json: book.average_rating, status: :created }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rating_params
    params[:rating].permit(:score, :book_id, :user_id,)
  end
end
