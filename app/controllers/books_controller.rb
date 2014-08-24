class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :validate_user, only: [:edit, :update, :destroy]
  before_filter only: [:new, :create, :edit, :update, :destroy] do
    redirect_to :new_user_session unless current_user
  end
  helper_method :sort_column, :sort_direction

  # GET /books
  def index
    if current_user
      current_user.admin? ? @books = Book.all : @books = Book.user_book_index(current_user)
    else
      @books = Book.approved
    end
    @books = find_books @books if params[:search]
    @books = @books.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
  end

  # GET /books/1
  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.paginate(:page => params[:page])
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
    i = find_info_ids books
    a = find_author_ids books
    r = find_review_ids books
    rating_book_ids = find_by_average_rating books
    books.where(id: i + a + r + rating_book_ids)
  end

  def find_info_ids books
    info_ids = books.where('title LIKE ? OR isbn_10 LIKE ? OR isbn_13 LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").pluck(:id)
  end

  def find_author_ids books
    author_ids = Author.where('last_name LIKE ? OR first_name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%").pluck(:id)
  end

  def find_review_ids books
    book_ids = books.pluck(:id)
    reviews = Review.where(book_id: book_ids)
    review_book_ids = reviews.where('body LIKE ?', "%#{params[:search]}%").pluck(:book_id)
  end

  def find_by_average_rating books
    rating_ids = []
    if params[:search].to_i > 0 && params[:search].to_i <= 5
      score = params[:search].to_i
      books.each do |book|
        if book.average_rating < score + 1  && book.average_rating >= score
          rating_ids.push book.id
        end
      end
    end
    rating_ids
  end

  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
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
