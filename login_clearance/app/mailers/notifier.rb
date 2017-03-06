class Notifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.welcome.subject
  #
  # def welcome
  #   @greeting = "Hi"
  #
  #   mail to: "to@example.org"
  # end
  def welcome(user, sent_at = Time.now)
    subject    'Welcome!'
    recipients user.email
    from       'info@example.com'
    sent_on    sent_at

    body       :user => user
  end
end
