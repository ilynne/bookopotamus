class FollowsController < ApplicationController
  before_action :set_follow, only: [:update, :destroy]
  before_filter only: [:new] do
    redirect_to :new_user_session unless current_user
  end

  def index
  end

  def create
    @follow = Follow.new(follow_params)
    if @follow.save
      redirect_to @follow.book, notice: 'Follow preferences updated.'
    else
      redirect_to books, notice: 'Your preferences could not be updated.'
    end
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

  def destroy
    @follow.destroy
    render json: {}, status: :no_content
  end
  private

  def set_follow
    begin
      @follow = Follow.find(params[:id])
    rescue
      redirect_to books_path
    end
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def follow_params
    params[:follow].permit(:rating, :review, :book_id, :user_id)
  end
end
