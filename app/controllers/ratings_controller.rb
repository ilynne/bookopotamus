class RatingsController < ApplicationController

  def update
    @rating = Rating.find(params[:id])
    @book = @rating.book
    @user = @rating.user
    return false if @rating.update_attributes(score: params[:score])
    # render :partial => "shared/book_rating", :layout => false, :locals => {:book => @book}
    respond_to do |format|
      format.js
    end
  end
end
