module Landlord
  class AccountMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.welcome.subject
    #
    def welcome(account)
      @owner = account.owner
      @email = @owner.email
      @name = @owner.first_name
      if !@name
        @name = @email
      end
      @company_name = account.name
      @url = account_url(account)
      @token = nil
      if (!@owner.confirmed?)
        @token = @owner.confirmation_token
      end
      mail(to: @email, subject: "Welcome to your new account!")
    end

    def invite(membership)
      @greeting = "Hi"

      mail(to: membership.user.email, subject: "Existing user invited")
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.trial_will_end.subject
    #
    def trial_will_end(account)
      @greeting = "Hi"

      mail(to: account.owner.email, subject: "Trial Will End")
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.past_due.subject
    #
    def past_due(account)
      @greeting = "Hi"

      mail(to: account.owner.email, subject: "Past Due")
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.canceled.subject
    #
    def canceled(account)
      @greeting = "Hi"

      mail(to: account.owner.email, subject: "Canceled")
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.account_mailer.unpaid.subject
    #
    def unpaid(account)
      @greeting = "Hi"

      mail(to: account.owner.email, subject: "Unpaid")
    end
  end
end
