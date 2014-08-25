if Rails.env.development? or Rails.env.test?
  class OverrideMailRecipient
    def self.delivering_email(mail)
      mail.to = 'lynne@ilynne.com'
    end
  end
  ActionMailer::Base.register_interceptor(OverrideMailRecipient)
end