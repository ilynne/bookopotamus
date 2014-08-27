class ReviewsController < ApplicationController
  before_action :validate_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @reviews = params[:book_id].present? ? Review.where(book_id: params[:book_id]) : Review.all
    # @reviews = Review.all
    @reviews = @reviews.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
  end

  # def show
  #   @book = Book.find(params[:book_id])
  #   @reviews = @book.reviews
  #   # @reviews = Review.all
  #   @reviews = @reviews.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
  # end

  def create
    @review = Review.find_or_create_by(book_id: params[:review][:book_id], user_id: params[:review][:user_id])
    @review.body = params[:review][:body]
    @book = Book.find(params[:review][:book_id])
    unless @book.active
      redirect_to @book, notice: 'This book is disabled,' and return
    end
    if @review.save
      redirect_to @book, notice: 'Review was successfully submitted.'
    else
      redirect_to @book, notice: 'Error'
    end
  end

  def update
    @review = Review.find(params[:id])
    @book = @review.book
    unless @book.active
      redirect_to @book, notice: 'This book is disabled' and return
    end
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      redirect_to @book, notice: 'Error'
    end
  end

  private

  def sort_column
    Review.column_names.include?(params[:sort]) ? params[:sort] : 'score'
  end

  def validate_user
    redirect_to books_url if current_user.restricted?
  end

  def review_params
    params[:review].permit(:body, :user_id, :book_id)
  end
end
