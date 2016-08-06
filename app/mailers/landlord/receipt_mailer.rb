module Landlord
  class ReceiptMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.succeeded.subject
    #
    def succeeded(receipt)
      @receipt = receipt
      account = receipt.account
      email = account.owner.email
      cc = nil

      if (account.billing_info)
        cc = account.billing_info.cc_emails
      end

      mail(to: email, subject: 'Charge Succeeded', cc: cc)
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.failed.subject
    #
    def failed(receipt)
      @receipt = receipt
      account = receipt.account
      email = account.owner.email
      cc = nil

      mail(to: email, subject: 'Charge Failed', cc: cc)
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.refunded.subject
    #
    def refunded(receipt)
      @receipt = receipt
      account = receipt.account
      email = account.owner.email
      cc = nil
      
      mail(to: email, subject: 'Charge Refunded', cc: cc)
    end
  end
end
