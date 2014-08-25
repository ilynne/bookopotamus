class Notification < ActionMailer::Base
  default from: 'lynne@ilynne.com'

  def welcome_email(user)
    @user = user
    mail(:to => @user.email, subject: 'Welcome to Bookopotamus!', body: 'Welcome!')
  end

  def member_invite(options)
    @options = options
    @to = options[:email]
    @from = options[:from]
    @admin = true if options[:admin].present?
    mail(:to => @to, :from => @from, subject: 'An invitation to Bookopotamus', :locals => { :options =>  @options })
  end

  def book_reviewed(book, options = {})
    @book = book
    mail(to: 'queen@ilynne.com', subject: 'test', :locals => { book: @book })
  end
end
