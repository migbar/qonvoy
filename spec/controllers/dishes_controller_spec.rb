require 'spec_helper'

describe DishesController do
  mock_models :place, :dish
  
  describe :get => :show, :place_id => "14", :id => "42" do
    expects :find, :on => Place, :with => "14", :returns => place_proc # proc { mock_place }
    expects :find, :on => proc { mock_place.dishes }, :with => "42", :returns => dish_proc
    
    should_assign_to :place, :with => place_proc
    should_assign_to :dish, :with => dish_proc
    should_render_template :show
  end
  
  def mock_place(stubs={})
    @mock_place ||= mock_model(Place, {:dishes => mock("dishes association")}.merge(stubs))
  end
  
  # 
  # def place_proc
  #   proc { mock_place }
  # end
end
