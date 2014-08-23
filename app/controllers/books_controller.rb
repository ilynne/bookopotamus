class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_filter only: [:new, :create, :edit, :update, :destroy] do
    redirect_to :new_user_session unless current_user
  end

  # GET /books
  def index
    if current_user
      current_user.admin? ? @books = Book.all : @books = Book.where("user_id = ? OR approved = ?", current_user.id, 1)
    else
      @books = Book.approved
    end
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    # @book = Book.new(title: 'title', isbn_10: '1234567890', isbn_13: '123-1234567890', author_last: 'last', author_first: 'first')
    @book = Book.new
    @book.reviews.build(user: current_user, body: 'good')
    @book.ratings.build(user: current_user, score: 0)
    @book.build_author
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    @book.user = current_user
    rating = @book.ratings.build(user: current_user, score: params[:score]) if params[:score].present?
    if @book.save
      rating.save if rating.present?
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json {}
      end
    end
  end

  # DELETE /books/1
  def destroy
    action = 'deleted'
    if @book.user == current_user && @book.deleteable?
      @book.destroy
    else
      @book.update_attribute(:active, false)
      action = 'deactivated'
    end
    redirect_to books_url, notice: "Book was successfully #{action}."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    begin
      @book = Book.find(params[:id])
    rescue
      redirect_to books_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params[:book].permit(:title,
                         :isbn_10,
                         :isbn_13,
                         :author_id,
                         :score,
                         :approved,
                         :cover,
                         reviews_attributes: [:body, :user_id],
                         author_attributes: [:last_name, :first_name, :last_first])
  end
end
