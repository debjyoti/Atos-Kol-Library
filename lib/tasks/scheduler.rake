desc "This task is called upon by heroku scheduler add-on for applying fine and sending reminders"
task :check_due_date => :environment do
  puts "Start check_due_date task"
  books= Book.where("user_id is not null")
  books.each do |book|
    if(book.expires_on < (DateTime::now()-1)) then
      usr = User.find(book.user_id)
      usr.fine += 5
      if usr.save
        puts usr.name+' fined.'
        UserMailer.fine_notify(book.user.email, book.user.fine, book.title, book.user.admin.email).deliver
      else
        puts usr.name+' could not be fined because of the following errors.'
        usr.errors.each { |err| puts err }
      end
    elsif(book.expires_on < (DateTime::now()+1))
      if(book.blocked_by_id)
        UserMailer.due_date_notify_blocked(book.user.email, book.title, book.expires_on.to_s, book.user.admin.email, book.blocked_by.email, book.blocked_by.name).deliver
      else
        UserMailer.due_date_notify(book.user.email, book.title, book.expires_on.to_s).deliver
      end
    end
  end
  puts "End check_due_date task"
end
