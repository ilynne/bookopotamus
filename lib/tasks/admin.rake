namespace :bookopotamus do
  desc "deliver rating emails"
  task :rating_emails => :environment do
    user_ids = Follow.where(rating: true).distinct.pluck(:user_id)
    user_ids.each do |user_id|
      if user = User.find(user_id)
        # puts user.inspect
        after = user.last_rating_email.present? ? user.last_rating_email : 60.minutes.ago
        book_ids = Rating.where('updated_at >= ?', after).distinct.pluck(:book_id)
        # puts book_ids
        book_ids.each do |book_id|
          puts "sending to #{user.email}"
          book = Book.find(book_id)
          options = {to: user.email, action: 'rated', subject: 'Bookopotamus Rating Notice'}
          Notification.book_reviewed(book, options).deliver
        end
        user.update_attribute(:last_rating_email, DateTime.now)
      end
    end
  end

  task :review_emails => :environment do
    user_ids = Follow.where(review: true).distinct.pluck(:user_id)
    user_ids.each do |user_id|
      if user = User.find(user_id)
        # puts user.inspect
        after = user.last_review_email.present? ? user.last_review_email : 60.minutes.ago
        book_ids = Review.where('updated_at >= ?', after).distinct.pluck(:book_id)
        # puts book_ids
        book_ids.each do |book_id|
          puts "sending to #{user.email}"
          book = Book.find(book_id)
          options = {to: user.email, action: 'reviewed', subject: 'Bookopotamus Review Notice'}
          Notification.book_reviewed(book, options).deliver
          sleep(5) # make google happy
        end
        user.update_attribute(:last_review_email, DateTime.now)
      end
    end
  end

  desc "Do all tasks that need to be run very frequently"
  task :always_active_tasks => [:environment, :rating_emails] do
    puts "doing everything..."
  end

end # end of namespace
