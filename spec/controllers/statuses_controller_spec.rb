require 'spec_helper'

describe StatusesController do
  
  mock_models :status, :place
  
  def mock_status(stubs={})
    @mock_status ||= mock_model(Status, stubs)
  end
  
  def self.status_proc
    proc { mock_status }
  end
  
  describe :get => :edit, :id => "31" do
    before(:each) do
      login_user
    end
    
    expects :find, :on => proc { current_user.statuses }, :with => "31", :returns => proc { mock_status(:place => mock_place) }
    
    context "status is unprocessed" do
      expects :processed?, :on => status_proc, :returns => false
      should_assign_to :status, :with => status_proc
      should_render_template :edit

      context "status_body exists in session" do
        before(:each) do
          session[:status_body] = "Existing status"
        end

        expects :body=, :on => status_proc, :with => "Existing status"
        should_not_set_session :status_body
      end
    end
    
    context "status is processed" do
      expects :processed?, :on => status_proc, :returns => true
      should_redirect_to { place_dish_path(mock_place, mock_status.dish) }
    end
   end
  
  describe :put => :preview, :id => "31", :status => { :body => "Blah blah 5" } do
    before(:each) do
      login_user
    end
    
    expects :find,
      :on => proc { current_user.statuses },
      :with => "31",
      :returns => proc { mock_status(:body => "Blah blah 5") }
    
    expects :body=, :on => status_proc, :with => "Blah blah 5"
    
    context "failing to parse a newly submitted status" do
      expects :try_parsing, :on => Status, :with => "Blah blah 5", :returns => [false, {:rating => "5"}]
      
      should_assign_to :result, :with => {"rating" => "5"}
      should_assign_to :parse_success, :with => false
      should_set_session :status_body, :to => "Blah blah 5"
      should_render_template :edit
    end
    
    context "successfully parsing the new status" do
      expects :try_parsing, :on => Status, :with => "Blah blah 5", :returns => [true, {:rating => "5"}]
      
      should_assign_to :result, :with => {"rating" => "5"}
      should_assign_to :parse_success, :with => true
      should_set_session :status_body, :to => "Blah blah 5"
      should_render_template :preview
    end
  end
  
  describe :put => :update, :id => "31" do
    before(:each) do
      login_user
      session[:status_body] = "Blah blah 5"
    end
    
    expects :find,
      :on => proc { current_user.statuses },
      :with => "31",
      :returns => proc { mock_status(:body => "Blah blah 5") }
    
    expects :body=, :on => status_proc, :with => "Blah blah 5"
    
    context "successfully processing the updated status" do
      expects :process_updated_status!, :on => status_proc, :returns => true
      expects :place, :on => status_proc, :returns => place_proc
      
      context "place missing information" do
        expects :missing_information?, :on => place_proc, :returns => true
        should_redirect_to { edit_place_path(mock_place) }
        should_not_set_session :status_body
      end
      
      context "place not missing information" do
        expects :missing_information?, :on => place_proc, :returns => false
        should_redirect_to { place_dish_path(mock_place, mock_status.dish) }
        should_not_set_session :status_body
      end
    end
    
    context "failing to proess the updated status" do
      expects :process_updated_status!, :on => status_proc, :returns => false
      should_redirect_to { edit_status_path(mock_status) }
      should_not_set_session :status_body
    end
  end
  
  def mock_status(stubs={})
    @mock_status ||= mock_model(Status, {:dish => mock_model(Dish)}.merge(stubs))
  end
  
  def current_user(stubs={})
    @current_user ||= mock_model(User, {
      :statuses => mock("current_user.statuses")
    }.merge(stubs))
  end
  
  
end
