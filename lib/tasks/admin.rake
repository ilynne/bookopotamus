namespace :bookopotamus do
  desc "deliver rating emails"
  task :rating_emails => :environment do
    user_ids = Follow.all.distinct.pluck(:user_id)
    user_ids.each do |user_id|
      user = User.find(user_id)
      puts user.email
      email_prefs = user.email_prefs
      if email_prefs.present? && email_prefs.opt_out?
        puts 'user opted out'
      else
        after = user.last_rating_email.present? ? user.last_rating_email : 60.minutes.ago
        if email_prefs.present? && email_prefs.all_ratings?
          puts 'all ratings'
          book_ids = Follow.where(user_id: u.id).pluck(:book_id)
          rated_book_ids = Rating.where(book_id: book_ids).where('updated_at >= ?', after).distinct.pluck(:book_id)
          rated_book_ids.each do |rbi|
            book = Book.find(book_id)
            options = {to: user.email, action: 'rated', subject: 'Bookopotamus Rating Notice'}
            Notification.book_reviewed(book, options).deliver
          end
          user.update_attribute(:last_rating_email, DateTime.now)
        else
          puts 'by each book'
          book_ids = Follow.where(user_id: user.id, rating: true).pluck(:book_id)
          rated_book_ids = Rating.where(book_id: book_ids).where('updated_at >= ?', after).distinct.pluck(:book_id)
          rated_book_ids.each do |rbi|
            book = Book.find(rbi)
            options = {to: user.email, action: 'rated', subject: 'Bookopotamus Rating Notice'}
            Notification.book_reviewed(book, options).deliver
          end
          user.update_attribute(:last_rating_email, DateTime.now)
        end
      end
    end

  end

  desc "deliver review emails"
  task :review_emails => :environment do
    user_ids = Follow.all.distinct.pluck(:user_id)
    user_ids.each do |user_id|
      user = User.find(user_id)
      puts user.email
      email_prefs = user.email_prefs
      if email_prefs.present? && email_prefs.opt_out?
        puts 'user opted out'
      else
        after = user.last_review_email.present? ? user.last_review_email : 60.minutes.ago
        if email_prefs.present? && email_prefs.all_reviews?
          puts 'all reviews'
          book_ids = Follow.where(user_id: u.id).pluck(:book_id)
          rated_book_ids = Review.where(book_id: book_ids).where('updated_at >= ?', after).distinct.pluck(:book_id)
          rated_book_ids.each do |rbi|
            book = Book.find(book_id)
            options = {to: user.email, action: 'reviewed', subject: 'Bookopotamus Review Notice'}
            Notification.book_reviewed(book, options).deliver
          end
          user.update_attribute(:last_review_email, DateTime.now)
        else
          puts 'by each book'
          book_ids = Follow.where(user_id: user.id, review: true).pluck(:book_id)
          rated_book_ids = Review.where(book_id: book_ids).where('updated_at >= ?', after).distinct.pluck(:book_id)
          rated_book_ids.each do |rbi|
            book = Book.find(rbi)
            options = {to: user.email, action: 'reviewed', subject: 'Bookopotamus Rating Notice'}
            Notification.book_reviewed(book, options).deliver
          end
          user.update_attribute(:last_review_email, DateTime.now)
        end
      end
    end

  end

  # task :review_emails => :environment do
  #   user_ids = Follow.where(review: true).distinct.pluck(:user_id)
  #   user_ids.each do |user_id|
  #     if user = User.find(user_id)
  #       # puts user.inspect
  #       after = user.last_review_email.present? ? user.last_review_email : 60.minutes.ago
  #       book_ids = Review.where('updated_at >= ?', after).distinct.pluck(:book_id)
  #       # puts book_ids
  #       book_ids.each do |book_id|
  #         puts "sending to #{user.email}"
  #         book = Book.find(book_id)
  #         options = {to: user.email, action: 'reviewed', subject: 'Bookopotamus Review Notice'}
  #         Notification.book_reviewed(book, options).deliver
  #         sleep(5) # make google happy
  #       end
  #       user.update_attribute(:last_review_email, DateTime.now)
  #     end
  #   end
  # end

  desc "Do all tasks that need to be run very frequently"
  task :always_active_tasks => [:environment, :rating_emails] do
    puts "doing everything..."
  end

end # end of namespace
