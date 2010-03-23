require 'spec_helper'

describe StatusesController do
  def mock_status(stubs={})
    @mock_status ||= mock_model(Status, stubs)
  end
  
  def self.status_proc
    proc { mock_status }
  end
  
  describe :get => :show, :id => "31" do
    before(:each) do
      login_user
    end
    
    expects :find, :on => proc { current_user.statuses }, :with => "31", :returns => status_proc
    should_assign_to :status, :with => status_proc
    should_render_template :show
  end
  
  def current_user(stubs={})
    @current_user ||= mock_model(User, {
      :statuses => mock("current_user.statuses")
    }.merge(stubs))
  end
end
