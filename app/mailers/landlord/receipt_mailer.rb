module Landlord
  class ReceiptMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.succeeded.subject
    #
    def succeeded(receipt)
      @receipt = receipt
      email = receipt.account.owner.email
      mail(to: email, subject: 'Charge Succeeded')
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.failed.subject
    #
    def failed(receipt)
      @receipt = receipt
      email = receipt.account.owner.email
      mail(to: email, subject: 'Charge Failed')
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.receipt_mailer.refunded.subject
    #
    def refunded(receipt)
      @receipt = receipt
      email = receipt.account.owner.email
      mail(to: email, subject: 'Charge Refunded')
    end
  end
end
