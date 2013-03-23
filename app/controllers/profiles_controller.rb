class ProfilesController < ApplicationController
  def show
   @user = current_user 
  end

  def index
    @unapproved_users = User.find_all_by_approved(false)
    @users = User.find_all_by_approved(true)
  end

  def approve_user
    usr = User.find(params[:profile_id])
    usr.approved = true
    if(usr.save)
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
    unless usr.admin?
      usr.admin = true
      notice_text= 'Admin right given to user '+usr.name
    else
      usr.admin = false
      notice_text= 'Admin right revoked from user '+usr.name
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
    name = usr.name
    usr.destroy
    redirect_to :back, notice: 'User '+name+' removed'
  end

end
