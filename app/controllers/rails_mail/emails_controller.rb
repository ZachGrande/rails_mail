module RailsMail
  class EmailsController < BaseController
    # GET /emails
    def index
      @emails = Email.order(created_at: :desc)
      @email = params[:id] ? Email.find(params[:id]) : Email.last
    end

    # GET /emails/1
    def show
      @emails = Email.order(created_at: :desc)
      @email = Email.find(params[:id])
      if request.headers["Turbo-Frame"]
        render partial: "rails_mail/emails/show", locals: { email: @email }
      else
        render :index
      end
    end
  end
end
