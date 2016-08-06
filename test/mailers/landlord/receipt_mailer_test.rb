require 'test_helper'

module Landlord
  class ReceiptMailerTest < ActionMailer::TestCase
    test "succeeded" do
      mail = ReceiptMailer.succeeded
      assert_equal "Succeeded", mail.subject
      assert_equal ["to@example.org"], mail.to
      assert_equal ["from@example.com"], mail.from
      assert_match "Hi", mail.body.encoded
    end

    test "failed" do
      mail = ReceiptMailer.failed
      assert_equal "Failed", mail.subject
      assert_equal ["to@example.org"], mail.to
      assert_equal ["from@example.com"], mail.from
      assert_match "Hi", mail.body.encoded
    end

    test "refunded" do
      mail = ReceiptMailer.refunded
      assert_equal "Refunded", mail.subject
      assert_equal ["to@example.org"], mail.to
      assert_equal ["from@example.com"], mail.from
      assert_match "Hi", mail.body.encoded
    end

  end
end
