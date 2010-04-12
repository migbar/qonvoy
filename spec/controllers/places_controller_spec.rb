require 'spec_helper'

describe PlacesController do
  include ActionView::Helpers::RecordIdentificationHelper
  
  mock_models :place
  
  def mock_map
    @mock_map ||= mock(GMap)
  end
  
  def self.map_proc
    proc { mock_map }
  end
  
  def mock_marker
    @mock_marker ||= mock(GMarker)
  end
  
  def self.marker_proc
    proc { mock_marker }
  end
  
  describe :get => :edit, :id => "42" do
    expects :find, :on => Place, :with => "42", :returns => place_proc
    should_assign_to :place, :with => place_proc
    should_render_template :edit
    
    it "requires a user to be logged in" do
      pending "TODO: when we implement the place edit page"
    end
  end
  
  describe :get => :show, :id => "42" do
    let(:dishes) { (1..3).map { mock_model(Dish) } }
    
    expects :find,
      :on      => Place,
      :with    => "42",
      :returns => proc { mock_place(:name => "Nobu", :latitude => 42, :longitude => 24, :dishes => dishes) }
    
    expects :descend_by_rating, :on => proc { mock_place.dishes }, :returns => proc { dishes }
    
    
    expects :new, :on => GMap, :with => proc { dom_id(mock_place) }, :returns => map_proc
    
    expects :control_init, :on => map_proc, :with => {:large_map => false, :small_map => true, :scale => true}
    expects :center_zoom_init, :on => map_proc, :with => [[42, 24], 11]
    
    expects :new,
      :on => GMarker,
      :with => [[42, 24], {:title => "Nobu", :info_window => "bubble content"}],
      :returns => marker_proc
    
    expects :render_to_string,
      :on      => proc { controller },
      :with    => proc { { :partial => "bubble", :locals => { :place => mock_place } } },
      :returns => "bubble content"
    
    expects :overlay_init,
      :on => map_proc,
      :with => marker_proc
    
    should_assign_to :place, :with => place_proc
    should_assign_to :dishes, :with => proc { dishes }
    should_render_template :show
    
  end
  
  
end
