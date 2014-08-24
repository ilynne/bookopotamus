class Notification < ActionMailer::Base
  default from: 'lynne@ilynne.com'

  def welcome_email(user)
    @user = user
    mail(:to => @user.email, subject: 'Welcome to Bookopotamus!', body: 'Welcome!')
  end

  def member_invite(options)
    @to = options[:email]
    @from = options[:from]
    body = "#{@from} has invited you to join Bookopotamus. Go to http://bookopotamus.dev for more info."
    mail(:to => @to, :from => @from, subject: 'An invitation to Bookopotamus', body: body)
  end
end
