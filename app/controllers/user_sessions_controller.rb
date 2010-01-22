class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def show
    redirect_back_or_default root_path
  end

  def create
    @user_session = UserSession.new
    @user_session.save do |result|
      if result
        flash[:notice] = "Welcome #{@user_session.record}!"
        redirect_back_or_default root_path
      else
        if params[:denied]
          flash[:notice] = "You did not allow Qonvoy to use your Twitter account"
          redirect_to root_path
        else
          # Hoptoad.notify "Hack attack!"
        end
      end
    end
  end
end