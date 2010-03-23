class StatusesController < ApplicationController
  before_filter :require_user
  
  def show
    @status = current_user.statuses.find(params[:id])
  end
end