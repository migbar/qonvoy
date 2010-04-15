require 'spec_helper'

describe DishesController do
  mock_models :place, :dish
  
  describe :get => :show, :place_id => "14", :id => "42" do
    let(:dishes)   { (1..3).map { mock_model(Dish) } }
    let(:statuses) { (1..3).map { mock_model(Status) } }
    let(:map)      { mock(MapPresenter) }
    
    expects :find, :on => Place, :with => "14", :returns => place_proc # proc { mock_place }
    expects :find, :on => proc { mock_place.dishes }, :with => "42", :returns => dish_proc
    expects :descend_by_processed_at, :on => proc { mock_dish.processed_statuses }, :returns => proc { statuses }    
    expects :descend_by_rating, :on => proc { mock_place.dishes }, :returns => proc { dishes }
    expects :new, :on => MapPresenter, :with => proc { [mock_place, {:controller => controller}] }, :returns => proc { map }
    
    should_assign_to :map, :with => proc { map }
    should_assign_to :statuses, :with => proc { statuses }
    should_assign_to :place, :with => place_proc
    should_assign_to :dish, :with => dish_proc
    should_assign_to :dishes, :with => proc { dishes }
    should_render_template :show
  end
  
  
  def mock_dish
    @mock_dish ||= stub_model(Dish)
  end
  
  def mock_place(stubs={})
    @mock_place ||= mock_model(Place, {:dishes => mock("dishes association")}.merge(stubs))
  end
end
