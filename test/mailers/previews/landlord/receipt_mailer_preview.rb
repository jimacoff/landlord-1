module Landlord
  # Preview all emails at http://localhost:3000/rails/mailers/receipt_mailer
  class ReceiptMailerPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/receipt_mailer/succeeded
    def succeeded
      ReceiptMailer.succeeded
    end

    # Preview this email at http://localhost:3000/rails/mailers/receipt_mailer/failed
    def failed
      ReceiptMailer.failed
    end

    # Preview this email at http://localhost:3000/rails/mailers/receipt_mailer/refunded
    def refunded
      ReceiptMailer.refunded
    end

  end
end
