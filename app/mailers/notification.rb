class Notification < ActionMailer::Base
  default from: 'lynne@ilynne.com'

  def welcome_email(user)
    @user = user
    mail(:to => @user.email, subject: 'Welcome to Bookopotamus!', body: 'Welcome!')
  end
end
