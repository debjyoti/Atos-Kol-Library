class BooksController < ApplicationController
  # GET /books
  # GET /books.json

  SELECT_PROMPT = 'Select Category'

  def index
    @books = Book.order(:title)
    set_up_category_selection

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  def filter_category
    @selected_category = params[:category_name]
    if(@selected_category == 'All' or @selected_category == SELECT_PROMPT)
      @books = Book.order(:title)
    else
      cat = Category.find_by_name(params[:category_name])
      #assumption: category_name will always exist in category table
      @books = cat.books.order(:title)
    end
    @category_list = Category.pluck(:name)
    @category_list << 'All'

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @articles }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  def send_request
    bk = Book.find(params[:book_id])
    if(bk.user_id)
      redirect_to :back, notice: 'Sorry, the book is not available anymore.'
    else
      bk.user_id = current_user.id
      bk.pending_approval = true
      bk.expires_on = DateTime::now() + bk.category.duration
      if bk.save
        UserMailer.book_request_notify(bk.title, bk.user.name, current_user.admin.email).deliver
        redirect_to :back, notice: 'Please collect the book.'
      else
        redirect_to :back, alert: 'The operation failed. Please inform administrator.'
      end
    end
  end

  def issue_to_user
    bk = Book.find(params[:book_id])
    bk.pending_approval = false
    date_now = DateTime::now()
    bk.issued_on = date_now
    if bk.save
      redirect_to :back, notice: bk.title+' issued till '+ bk.expires_on.strftime("%d/%m/%Y")+' to '+bk.user.name
    else
      redirect_to :back, alert: 'The operation failed. Please inform administrator.'
    end
  end

  def renew_duration
    bk = Book.find(params[:book_id])
    bk.expires_on = DateTime::now() + bk.category.duration
    if bk.save
      redirect_to :back, notice: bk.title+' renewed till '+ bk.expires_on.strftime("%d/%m/%Y")+'.'
    else
      redirect_to :back, alert: 'The operation failed. Please inform administrator.'
    end
  end

  def cancel_request
    bk = Book.find(params[:book_id])
    bk.user_id = nil
    bk.issued_on = nil
    bk.expires_on = nil
    bk.pending_approval = false
    if bk.save
      redirect_to :back, notice: 'Request for '+bk.title+' has been canceled'
    else
      redirect_to :back, alert: 'Error occurred. Please inform administrator.'
    end
  end

  def return_to_library
    bk = Book.find(params[:book_id])
    to_email = bk.user.email
    bk.user_id = nil
    bk.issued_on = nil
    bk.expires_on = nil
    bk.pending_approval = false
    if bk.save
      UserMailer.book_return_notify(to_email, bk.title).deliver
      redirect_to :back, notice: 'Book '+bk.title+' has been returned to library.'
    else
      redirect_to :back, alert: 'Error occurred. Please inform administrator.'
    end
  end

  def show_issued
    @books = Book.where("user_id is not null").order(:title)
    respond_to do |format|
      format.html # show_issued_books.html.erb
      format.json { render json: @books }
    end
  end

  def show_pending_approvals
    @books = Book.find_all_by_pending_approval(true)
    respond_to do |format|
      format.html # show_pending_approvals.html.erb
      format.json { render json: @books }
    end
  end

  private

  def set_up_category_selection
    @category_list = Category.pluck(:name)
    @category_list << SELECT_PROMPT
    @selected_category = SELECT_PROMPT
  end
end
