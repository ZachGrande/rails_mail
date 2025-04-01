module RailsMail
  class Configuration
    attr_accessor :authentication_callback, :show_clear_all_button_callback,
                  :trim_emails_older_than, :trim_emails_max_count,
                  :enqueue_trim_job

    def initialize
      @authentication_callback = nil
      @show_clear_all_button_callback = nil
      @trim_emails_older_than = nil
      @trim_emails_max_count = nil
      @enqueue_trim_job = ->(email) { RailsMail::TrimEmailsJob.perform_later }
    end

    def authenticate(&callback)
      unless callback.nil? || callback.respond_to?(:call)
        raise ArgumentError, "authentication_callback must be nil or respond to #call"
      end
      @authentication_callback = callback
    end

    def show_clear_all_button(&callback)
      unless callback.nil? || callback.respond_to?(:call)
        raise ArgumentError, "show_clear_all_button must be nil or respond to #call"
      end
      @show_clear_all_button_callback = callback
    end
  end
end
