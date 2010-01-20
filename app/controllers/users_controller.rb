class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:create]
  
  def create
  end
end