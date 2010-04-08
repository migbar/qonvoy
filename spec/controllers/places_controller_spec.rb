require 'spec_helper'

describe PlacesController do
  mock_models :place
  
  describe :get => :edit, :id => "42" do
    expects :find, :on => Place, :with => "42", :returns => place_proc
    should_assign_to :place, :with => place_proc
    should_render_template :edit
    
    it "requires a user to be logged in" do
      pending "TODO: when we implement the place edit page"
    end
  end
  
  describe :get => :show, :id => "42" do
    expects :find, :on => Place, :with => "42", :returns => place_proc
    should_assign_to :place, :with => place_proc
    should_render_template :show
  end
end
