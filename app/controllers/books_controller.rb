class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
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
    @book = Book.find(params[:book_id])
    if(@book.user_id)
      redirect_to :back, notice: 'Sorry, the book is not available anymore.'
    else
      @book.user_id = current_user.id
      if @book.save
        redirect_to :back, notice: 'Please go and collect the book.'
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
    bk.expires_on = date_now + bk.category.duration
    if bk.save
      redirect_to :back, notice: bk.title+' issued till '+ bk.expires_on.strftime("%d/%m/%Y")+' to '+bk.user.name
    else
      redirect_to :back, alert: 'The operation failed. Please inform administrator.'
    end
  end

  def show_pending_approvals
    @books = Book.find_all_by_pending_approval(true)
    respond_to do |format|
      format.html # show_pending_approvals.html.erb
      format.json { render json: @books }
    end
  end
end
