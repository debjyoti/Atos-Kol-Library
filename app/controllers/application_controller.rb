class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
   profile_path(current_user.id)
  end

  private

  def authorize
    unless (user_signed_in? and current_user.is_admin?)
      redirect_to books_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
