module RailsMail
  class Email < ApplicationRecord
    include RailsMail::Engine.routes.url_helpers
    store_accessor :data, :from, :to, :cc, :bcc, :subject, :body, :content_type, :attachments

    validates :from, presence: true
    validates :to, presence: true

    after_create_commit :broadcast_email
    after_create_commit :enqueue_trim_job

    scope :search, ->(query) {
      where("CAST(data AS CHAR) LIKE :q", q: "%#{query}%")
    }

    def text?
      content_type&.include?("text/plain")
    end

    def html?
      content_type&.include?("text/html")
    end

    def next_email
      RailsMail::Email.where("id < ?", id).last || RailsMail::Email.first
    end

    private

    def broadcast_email
      return unless defined?(::Turbo) && defined?(::ActionCable)

      ::Turbo::StreamsChannel.broadcast_prepend_to(
        "rails_mail:emails",
        target: "email-sidebar",
        partial: "rails_mail/shared/email",
        locals: { email: self, email_path: email_path(self) }
      )
    rescue StandardError => e
      Rails.logger.error "RailsMail::Email#broadcast_email failed: #{e.message}"
    end

    def enqueue_trim_job
      RailsMail.configuration.enqueue_trim_job.call(self)
    rescue StandardError => e
      Rails.logger.error "RailsMail::Email#enqueue_trim_job Failed: #{e.message}"
    end
  end
end
