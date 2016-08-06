require 'test_helper'

module Landlord
  class SupportMailerTest < ActionMailer::TestCase
    test "message" do
      mail = SupportMailer.message
      assert_equal "Message", mail.subject
      assert_equal ["to@example.org"], mail.to
      assert_equal ["from@example.com"], mail.from
      assert_match "Hi", mail.body.encoded
    end

  end
end
