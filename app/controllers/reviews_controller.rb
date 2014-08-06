class ReviewsController < ApplicationController

  def index
    @reviews = Review.all
  end

private

  def review_params
    params[:review].permit(:body, :user_id, :book_id)
  end

end
