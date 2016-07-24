module Landlord
  class AccountMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.welcome.subject
    #
    def welcome(account)
      @email = account.owner.email
      @name = account.owner.first_name
      if !@name
        @name = @email
      end
      @company_name = account.name
      @url = account_url(account)
      mail(to: @email, subject: "Welcome to your account!")
    end
  end
end
