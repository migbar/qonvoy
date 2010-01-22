class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:create]
  
  # POST /account
  def create
    @user = User.new
    
    @user.save do |result|
      if result
        redirect_to root_path
        flash[:notice] = "Thank you for registering #{current_user}, your account has been created!"
      else
        if params[:denied]
          flash[:notice] = "You did not allow Qonvoy to use your Twitter account"
        else
          notify_hoptoad(:error_message => "Hack Attack!")
        end
        redirect_to root_path
      end
    end
  end
end