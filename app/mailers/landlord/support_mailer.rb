module Landlord
  class SupportMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.support_mailer.message.subject
    #
    def message(subject, message)
      @message = message

      mail(to: 'support@example.com', subject: subject)
    end
  end
end
