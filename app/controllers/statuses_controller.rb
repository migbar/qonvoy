class StatusesController < ApplicationController
  before_filter :require_user
  before_filter :find_status, :only => [:edit, :update, :preview]

  def edit
    # redirect_to @status and return if @status.processed?
    @status.body = session.delete(:status_body) if session[:status_body]
  end
  
  def preview
    session[:status_body] = @status.body = params[:status][:body]
    @parse_success, @result = Status.try_parsing(@status.body)
    render :edit unless @parse_success
  end
  
  def update
    @status.body = session.delete(:status_body)
    if @status.process_updated_status!
      place = @status.place
      if place.missing_information?
        redirect_to [:edit, place] and return
      else
        redirect_to [place, @status.dish] and return
      end
    else
      redirect_to [:edit, @status]
    end
  end

  private
  
  def find_status
    @status = current_user.statuses.find(params[:id])
  end
end