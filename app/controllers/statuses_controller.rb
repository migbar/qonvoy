class StatusesController < ApplicationController
  before_filter :require_user
  before_filter :find_status, :only => [:edit, :parse]

  def edit
    render
  end
  
  def parse
    @parse_success, @result = Status.try_parsing(params[:status][:body])
  end

  private
  
  def find_status
    @status = current_user.statuses.find(params[:id])
  end
end