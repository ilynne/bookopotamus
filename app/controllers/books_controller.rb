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
    @reviews = @book.reviews.order('score desc').first(3)
    set_follow if current_user
  end

  # GET /books/new
  def new
    @book = Book.new(user: current_user)
    @book.reviews.build(user: current_user, body: 'good')
    @book.ratings.build(user: current_user, score: 0)
    @book.build_author
    @book.follows.build(user_id: current_user.id, rating: true, review: true)
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    rating = @book.ratings.build(user: current_user, score: params[:score]) if params[:score].present?
    if @book.save
      rating.save if rating.present?
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new, notice: 'There was a problem.'
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

  def user
    @user = User.find(params[:user_id])
    if @user == current_user
      @books = @user.books.paginate(:page => params[:page])
    else
      @books = @user.books.where('approved = ?', true).paginate(:page => params[:page])
    end
    render template: 'books/index'
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

  def set_follow
    @follow = @book.follows.where(user_id: current_user).first
  end

  def validate_user
    unless @book.user == current_user
      redirect_to books_url
    end
  end

  def find_books books
    i = find_info_ids books
    a = find_author_ids
    r = find_review_ids books
    rating_book_ids = []
    rating_book_ids = find_by_average_rating books
    books.where(id: i + a + r + rating_book_ids)
  end

  def find_info_ids books
    info_ids = books.where('title LIKE ? OR isbn_10 LIKE ? OR isbn_13 LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").pluck(:id)
  end

  def find_author_ids
    author_ids = Author.where('last_name LIKE ? OR first_name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%").pluck(:id)
  end

  def find_review_ids books
    book_ids = books.pluck(:id)
    reviews = Review.where(book_id: book_ids)
    review_book_ids = reviews.where('body LIKE ?', "%#{params[:search]}%").pluck(:book_id)
  end

  def find_by_average_rating books
    score = params[:search].to_i
    Book.where('saved_rating < ? && saved_rating >= ?', score + 1, score).pluck(:id)
  end

  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : 'saved_rating'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
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
                         author_attributes: [:last_name, :first_name, :last_first],
                         follows_attributes: [:user_id, :review, :rating])
  end
end
