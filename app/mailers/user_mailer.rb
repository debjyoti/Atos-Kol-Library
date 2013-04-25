class UserMailer < ActionMailer::Base
  default from: "atos.kol.library@gmail.com"

  def approval_notify(user)
    @user = user
    admins = User.find_all_by_is_admin(true).map(&:email)
    mail(:to => admins, :subject => "New user waiting for approval")
  end

  def book_request_notify(bk_name, requester_name, admin_email)
    @book_name = bk_name
    @requester_name = requester_name
    mail(:to => admin_email, :subject => "Book '"+bk_name+"' requested by "+requester_name)
  end

  def account_activation_notify(to_email)
    mail(:to => to_email, :subject => "Welcome to the Atos Library")
  end

  def book_return_notify(to_email, book_name)
    @book_name = book_name
    mail(:to => to_email, :subject => "Book '"+book_name+"' returned.")
  end

  def book_availibility_notify(to_email, book_name)
    @book_name = book_name
    mail(:to => to_email, :subject => "Book '"+book_name+"' is available.")
  end

  def fine_notify(to_email, fine_amount, book_name, admin_email)
    @fine_amount = fine_amount
    @book_name = book_name
    mail(:to => to_email, :cc => admin_email, :subject => "IMPORTANT! Library Defaulter.")
  end

  def due_date_notify(to_email, book_name, book_due_date)
    @book_name = book_name
    @book_due_date = book_due_date
    mail(:to => to_email, :subject => "Reminder: Book '"+book_name+"' due date is approaching.")
  end

  def due_date_notify_blocked(to_email, book_name, book_due_date, admin_email, requester_email, requester_name)
    @book_name = book_name
    @book_due_date = book_due_date
    @requester_name = requester_name
    cc_emails = admin_email+", "+requester_email
    mail(:to => to_email, :cc => cc_emails, :subject => "Reminder: Book '"+book_name+"' due date is approaching.")
  end

end
