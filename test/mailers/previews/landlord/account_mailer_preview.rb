module Landlord
  # Preview all emails at http://localhost:3000/rails/mailers/account_mailer
  class AccountMailerPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/account_mailer/welcome
    def welcome
      AccountMailer.welcome
    end

  end
end
