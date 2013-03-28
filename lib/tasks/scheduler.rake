desc "This task is called upon by heroku scheduler add-on"
task :check_due_date => :environment do
  books= Book.where("user_id is not null")
  books.each do |book|
    if(book.expires_on < (DateTime::now()-1)) then
      usr = User.find(book.user_id)
      usr.fine += 5
      if usr.save
        puts usr.name+' fined.'
        UserMailer.fine_notify(book.user.email, book.user.fine, book.title).deliver
      else
        puts usr.name+' could not be fined because of the following errors.'
        usr.errors.each { |err| puts err }
      end
    elsif(book.expires_on < (DateTime::now()+1))
      UserMailer.due_date_notify(book.user.email, book.title, book.expires_on.to_s).deliver
    end
  end
end
