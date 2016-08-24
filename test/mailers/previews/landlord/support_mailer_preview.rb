module Landlord
  # Preview all emails at http://localhost:3000/rails/mailers/support_mailer
  class SupportMailerPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/support_mailer/notification
    def notification
      SupportMailer.notification
    end

  end
end
