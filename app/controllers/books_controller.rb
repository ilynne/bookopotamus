class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :validate_user, only: [:edit, :update, :destroy]
  before_filter only: [:new, :create, :edit, :update, :destroy] do
    redirect_to :new_user_session unless current_user
  end

  # GET /books
  def index
    if current_user
      current_user.admin? ? @books = Book.all : @books = Book.user_book_index(current_user)
    else
      @books = Book.approved
    end
    @books = find_books @books if params[:search]
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

  def validate_user
    unless @book.user == current_user
      redirect_to books_url
    end
  end

  def find_books books
    book_ids = books.pluck(:id)
    b = books.where('title LIKE ? OR isbn_10 LIKE ? OR isbn_13 LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    authors = Author.where('last_name LIKE ? OR first_name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%").pluck(:id)
    a = books.where(author_id: authors)
    # r = books.where(id: books.first.id)
    reviews = Review.where(book_id: book_ids)
    review_book_ids = reviews.where('body LIKE ?', "%#{params[:search]}%").pluck(:book_id)
    r = books.where(id: review_book_ids)
    # puts reviews.inspect
    # r = books.where(id: reviews.join(','))
    b + a + r
    # r
    # book_ids = books.pluck(:id)
    # Book.where('title LIKE ? OR isbn_10 LIKE ? OR isbn_13 LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    # # ids = Author.where('last_name LIKE ? OR first_name LIKE ?', "%#{search}%", "%#{search}%").pluck(:id)
    # author_ids = Book.where(author_id: authors.join(',')).pluck(:id)
    # # book_reviews = Review.where(book_id: book_ids.join(','))
    # # book_reviews = book_reviews.where('body LIKE ?', "%#{params[:search]}%")
    # # # reviews = reviews.where('body LIKE ?', "%#{params[:search]}%")
    # # reviews_ids = book_reviews.pluck(:book_id)
    # # review_where = books.where(id: reviews_ids.join(','))
    # # puts review_where.inspect
    # # r = find_reviews book_ids
    # # puts r.inspect
    # ids = author_ids + book_ids
    # Book.where(id: ids.join(','))
    # reviews_where
    # author_where
    # book_where
  end

  def find_reviews book_ids
    Review.where('body LIKE ?', "%#{params[:search]}%")
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
