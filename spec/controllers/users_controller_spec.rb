require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = stub_model(User, :create_or_update => true, :screen_name => "twitter_guy", :follow_me => true)
  end
  
  describe "handling POST create" do
    before(:each) do
      User.stub(:new).and_return(@user)
    end
    
    def post_with_valid_attributes
      controller.should_receive(:current_user).and_return(nil) # first time -> the filter that sends :current_user, expects nil
      controller.should_receive(:current_user).and_return(@user) # second time -> our flash message code, we expect a true user
      @user.should_receive(:valid?).and_return(true)
      post :create
    end
    
    def post_with_invalid_attributes(options={})
      @user.should_receive(:valid?).and_return(false)
      post :create, options
    end

    it "builds a new User from params and assigns it for the view" do
      User.should_receive(:new).and_return(@user)
      post_with_valid_attributes
      assigns[:user].should == @user
    end
    
    it "gets the user followed by Ratingbird" do
      @user.should_receive(:follow_me)
      post_with_valid_attributes
    end
    
    it "redirects to the profile page and sets the flash message on success" do
      post_with_valid_attributes
      flash[:notice].should == "Thank you for registering twitter_guy, your account has been created!"
      response.should redirect_to(edit_profile_path)
    end
    
    it "sets the notice flash and redirects to the registration page if denied OAuth authentication" do
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
  
  describe "handling GET edit" do
    before(:each) do
      login_user
      @user = current_user
    end
    
    def do_get
      get :edit
    end
    
    it "assigns the current user for the view" do
      do_get
      assigns[:user].should == current_user
    end
        
    it "renders the edit template" do
      do_get
      response.should render_template(:edit)
    end
  end
  
  describe "handling PUT update" do
    before(:each) do
      login_user
      @user = current_user
    end
    
    def put_with_valid_attributtes
      @user.should_receive(:update_attributes).with("foo" => "bar").and_return(true)
      put :update, :user => { :foo => "bar" }
    end
      
    it "assigns the current user for the view" do
      put_with_valid_attributtes
      assigns[:user].should == current_user
    end
    
    it "sets the success flash and redirects to home page" do
      put_with_valid_attributtes
      flash[:success].should == "Saved your interests."
      response.should redirect_to(root_path)
    end
  end
end







