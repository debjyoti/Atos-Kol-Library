class ProfilesController < ApplicationController

  before_filter :authorize, except: [:show]

  def show
   @user = current_user 
   @user_admin = current_user.admin
   if current_user.is_admin?
    @unapproved_users_count = User.where("approved = false").count
    @books_to_lend_count = Book.where("pending_approval = true and user_id in (select user_id from users where admin_id = ?)", current_user.id).count
   end
  end

  def index
    @unapproved_users = User.find_all_by_approved(false)
    @users = current_user.members.order(:name)
    @admin_list = User.where("is_admin is true").pluck(:name)
    @user_list = User.pluck(:name)
    @user_list << "ALL"
  end

  def approve_user
    usr = User.find(params[:profile_id])
    usr.approved = true
    usr.admin_id = current_user.id
    if(usr.save)
      UserMailer.account_activation_notify(usr.email).deliver
      redirect_to :back, notice: 'User '+usr.name+ ' approved.'
    else
      redirect_to :back, alert: usr.errors.full_messages.to_s
    end
  end

  def edit
    @usr = User.find(params[:id])
  end

  def update
    @usr = User.find(params[:id])
    if @usr.update_attributes(params[:profile])
      redirect_to profiles_path
    else
      redirect_to :back, alert: @usr.errors.full_messages.to_s
    end
  end

  def toggle_admin_rights
    usr = User.find(params[:profile_id])
    if(current_user.id == usr.id)
      redirect_to :back, alert: 'Can not change admin rights of own user.'
      return
    end
    unless usr.is_admin?
      usr.is_admin = true
      notice_text= 'Admin right given to user '+usr.name
    else
      if(usr.members.count > 0)
        redirect_to :back, alert: 'There are members allocated to this admin. Can not revoke rights.'
        return
      else
        usr.is_admin = false
        notice_text= 'Admin right revoked from user '+usr.name
      end
    end
    if usr.save
      redirect_to :back, notice: notice_text
    else
      redirect_to :back, alert: usr.errors.full_messages.to_s
    end
  end

  def destroy
    usr = User.find(params[:id])
    if(usr.id == current_user.id)
      redirect_to :back, alert: 'Can not delete own user.'
      return
    end
    if(usr.members.count > 0)
      redirect_to :back, alert: 'Can not delete admin user as there are allocated members.'
      return
    end
    if(usr.books.count > 0)
      redirect_to :back, alert: 'Can not delete user as there are books lent to him.'
      return
    end
    if(usr.blocked_books.count > 0)
      redirect_to :back, alert: 'Can not delete user as there are books that he has blocked.'
      return
    end
    name = usr.name
    usr.destroy
    redirect_to :back, notice: 'User '+name+' removed'
  end

  def show_fines
    #anything i add here must be added in spend_money 'else' clause as there is a render
    @fined_users = User.where("fine > 0")
    @spending_history = Spending.order("created_at desc")
    @spending = Spending.new(user_id: current_user.id, when: DateTime::now())
    # 'when' is redundant, because of 'created_at', but I am too lazy to remove it
  end

  def charge_fine
    payment_amount = params[:payment_amount].delete(',').to_f
    user_id = params[:user_id].to_i
    usr = User.find(user_id)
    usr.fine -= payment_amount
    #assumption: current user money will not be nil, as the default value is 0
    current_user.money += payment_amount
    if (usr.save and current_user.save)
      redirect_to :back, notice: "Payment of Rs."+payment_amount.to_s+" has been successfully processed."
    else
      redirect_to :back, alert: 'Error: '+usr.errors.full_messages.to_s+", "+current_user.errors.full_messages.to_s
    end
  end

  def spend_money
    usr = User.find(current_user.id)
    usr.money -= params[:spending][:amount].delete(',').to_f
    @spending = Spending.new(params[:spending])

    respond_to do |format|
      if @spending.save and usr.save
       format.html { redirect_to :show_fines_profiles, notice: 'Spending was successfully posted' }
      else
        @fined_users = User.where("fine > 0")
        @spending_history = Spending.order("created_at desc")
        flash.now[:alert] = "Error"+@spending.errors.full_messages.to_s+", "+usr.errors.full_messages.to_s
        format.html { render action: "show_fines"}
      end
    end
  end

  def show_issue_history
    @usr = User.find(params[:profile_id])
    @usr_issue_history = @usr.book_issue_histories.order("created_at desc")  
    respond_to do |format|
      format.html
    end
  end

  def migrate_user
    admin_id = User.where("name = ?",params[:admin_name]).pluck(:id)
    User.where("admin_id = ?",admin_id).update_all(:admin_id => current_user.id)
    redirect_to :back, notice: "Users migrated successfully"
  end

end
