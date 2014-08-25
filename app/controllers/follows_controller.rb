class FollowsController < ApplicationController
  before_filter only: [:new] do
    redirect_to :new_user_session unless current_user
  end

  def index
  end

  # GET /books/id/follows/new
  def new
    @book = Book.find(params[:book_id])
    @rating = follow.find_or_create_by(user: current_user, book: @book)
    update_follow(@rating, @book)
  end

  def update
    @follow = Follow.find(params[:id])
    book = @follow.book
    if @follow.update(follow_params)
      redirect_to book, notice: 'Follow preferences updated.'
    else
      redirect_to book, notice: 'Your preferences could not be updated.'
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def follow_params
    params[:follow].permit(:rating, :review, :book_id, :user_id,)
  end
end
