class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def update
    @review = Review.find(params[:id])
    @book = @review.book
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      render redirect_to @book, notice: 'Error'
    end
  end

private

  def review_params
    params[:review].permit(:body, :user_id, :book_id)
  end

end
