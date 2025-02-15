require "application_system_test_case"

module RailsMail
  class DeleteEmailTest < ApplicationSystemTestCase
    setup do
      # Create a test email
      ActionMailer::Base.deliveries << Mail.new(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Test Email",
        body: "Test body"
      )
    end

    test "deleting an email from sidebar" do
      visit rails_mail.emails_path

      # Verify email exists before deletion
      assert_selector ".email-row", count: 1
      assert_text "Test Email"

      # Hover over email to reveal delete button and click it
      find(".group").hover

      # Accept the confirmation dialog and click delete
      accept_confirm do
        find("button[type='submit']").click
      end

      # Verify email is removed
      assert_no_selector ".email-row"
      assert_text "No emails at the moment"
      assert ActionMailer::Base.deliveries.empty?
    end

    teardown do
      ActionMailer::Base.deliveries.clear
    end
  end
end
