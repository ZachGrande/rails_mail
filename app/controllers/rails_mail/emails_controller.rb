module RailsMail
  class EmailsController < ApplicationController
    # GET /emails
    def index
      @emails = Email.order(created_at: :desc)
      @email = params[:id] ? Email.find(params[:id]) : Email.last
    end

    # GET /emails/1
    def show
      @emails = Email.order(created_at: :desc)
      @email = Email.find(params[:id])
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "email_content",
            partial: "rails_mail/emails/show",
            locals: { email: @email }
          )
        end
      end
    end
  end
end
