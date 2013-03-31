class ProfilesController < ApplicationController

  before_filter :authorize, except: [:show]

  def show
   @user = current_user 
   @user_admin = current_user.admin
   if current_user.is_admin?
    @unapproved_users_count = User.where("approved = false").count
    @books_to_lend_count = Book.where("pending_approval = true").count
   end
  end

  def index
    @unapproved_users = User.find_all_by_approved(false)
    @users = current_user.members
  end

  def approve_user
    usr = User.find(params[:profile_id])
    usr.approved = true
    usr.admin_id = current_user.id
    if(usr.save)
      UserMailer.account_activation_notify(usr.email).deliver
      redirect_to :back, notice: 'User '+usr.name+ ' approved.'
    else
      redirect_to :back, alert: usr.errors
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
      redirect_to :back, alert: @usr.errors
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
      redirect_to :back, alert: usr.errors
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
    @fined_users = User.where("fine > 0")
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
      redirect_to :back, alert: 'Error: '+usr.errors+", "+current_user.errors
    end
  end

end
