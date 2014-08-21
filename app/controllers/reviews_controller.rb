class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def create
    @review = Review.find_or_create_by(book_id: params[:review][:book_id], user_id: params[:review][:user_id])
    @review.body = params[:review][:body]
    @book = Book.find(params[:review][:book_id])
    return unless @book.active
    if @review.save
      redirect_to @book, notice: 'Review was successfully submitted.'
    else
      redirect_to @book, notice: 'Error'
    end
  end

  def update
    @review = Review.find(params[:id])
    @book = @review.book
    return unless @book.active
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      redirect_to @book, notice: 'Error'
    end
  end

  private

  def review_params
    params[:review].permit(:body, :user_id, :book_id)
  end
end
