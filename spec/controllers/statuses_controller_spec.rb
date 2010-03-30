require 'spec_helper'

describe StatusesController do
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
    
    expects :find, :on => proc { current_user.statuses }, :with => "31", :returns => status_proc
    should_assign_to :status, :with => status_proc
    should_render_template :edit
  end
  
  describe :put => :parse, :id => "31", :status => { :body => "Blah blah 5" } do
    before(:each) do
      login_user
    end
    
    expects :find, :on => proc { current_user.statuses }, :with => "31", :returns => status_proc
    expects :try_parsing, :on => Status, :with => "Blah blah 5", :returns => [false, {:rating => "5"}]
    should_assign_to :result, :with => {"rating" => "5"}
    should_assign_to :parse_success, :with => false
    should_render_template :parse
  end
  
  def current_user(stubs={})
    @current_user ||= mock_model(User, {
      :statuses => mock("current_user.statuses")
    }.merge(stubs))
  end
  
  
end
