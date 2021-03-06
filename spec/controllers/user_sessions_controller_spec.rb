require 'spec_helper'

describe UserSessionsController do
  before(:each) do
    activate_authlogic
    @user_session = UserSession.new
  end
  
  describe "handling GET show" do
    it "redirects to the new action" do
      get :show
      response.should redirect_to(root_path)
    end
  end
  
  describe "handling POST create" do
    before(:each) do
      UserSession.stub(:find).and_return(nil) # logged out
      UserSession.stub!(:new).and_return(@user_session)
      @user_session.stub!(:record).and_return(stub_model(User, :save => true, :to_s => 'my_login'))
    end
    
    def post_with_valid_attributes(options={})
      @current_user = mock_model(User) # option[:user_session] && options[:user_session][:login]
      controller.should_receive(:current_user).and_return(nil) # first time it is the filter that sends :current_user, expects nil
      @user_session.should_receive(:valid?).and_return(true)
      post :create, options
    end
    
    def post_with_invalid_attributes(options={})
      @user_session.should_receive(:valid?).and_return(false)
      post :create, options
    end

    it "builds a new User Session from params and assigns it for the view" do
      UserSession.should_receive(:new).and_return(@user_session)
      post_with_valid_attributes
      assigns[:user_session].should == @user_session
    end
    
    it "redirects to the home page and sets the flash message on success" do
      post_with_valid_attributes
      flash[:notice].should == "Welcome my_login!"
      response.should redirect_to(root_path)
    end
    
    it "sets the notice flash and redirects to the login page if denied OAuth authentication" do
      post_with_invalid_attributes(:denied => "foo")
      flash[:notice].should == "You did not allow Qonvoy to use your Twitter account"
      response.should redirect_to(root_path)
    end
    
    it "notifies hoptoad and redirects to the home page when trying to post with an invalid form" do
      controller.should_receive(:notify_hoptoad).with(:error_message => "Hack Attack!")
      post_with_invalid_attributes
      response.should redirect_to(root_path)
    end
  end
  
  describe "handling DELETE destroy" do
    def do_delete
      delete :destroy
    end
    
    it "redirects to the home page if not logged in (before filter)" do
      do_delete
      response.should redirect_to(root_path)
    end
    
    describe "when logged in" do
      before(:each) do
        login_user
        user_session.stub(:destroy)
      end
      
      it "destroys the current user session" do
        user_session.should_receive(:destroy)
        do_delete
      end
      
      it "sets the flash message and redirects to the home page" do
        do_delete
        flash[:notice].should == "You have logged out"
        response.should redirect_to(root_path)
      end
    end
    
    
  end
  
end