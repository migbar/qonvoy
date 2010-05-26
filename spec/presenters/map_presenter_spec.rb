require 'spec_helper'

describe MapPresenter do
  include ActionView::Helpers::RecordIdentificationHelper     
  include ActionController::Assertions::SelectorAssertions
  
  subject { MapPresenter.new(place, :controller => controller) }
  
  let(:place) { Factory.create(:place, :location => location) }
  let(:location) { Factory.create(:location, :bounds => { :sw => { :latitude => 1, :longitude => 2 }, :ne => {:latitude => 3, :longitude => 4} }) }
  let(:map) { mock(GMap).as_null_object }
  let(:controller) { mock("Controller", :render_to_string => bubble_content) }
  let(:place_marker) { mock(GrbMarker) }
  let(:bubble_content) { "bubble content" }
  
  before(:each) do
    GMap.stub(:new => map)
    GrbMarker.stub(:new => place_marker)
  end
  
  describe "#new" do
    context "when place has location" do
      it "builds a new map with the dom_id for the place" do
        GMap.should_receive(:new).with(dom_id(place, :map)).and_return(map)
        subject
      end
    
      it "inits the controls on the map" do
        map.should_receive(:control_init).with({:large_map => false, :small_map => true, :scale => true})
        subject
      end
    
      it "centers and zooms the map to the mappable location" do
        map.should_receive(:center_zoom_on_bounds_init).with([[1,2], [3,4]])
        subject
      end
    
      it "builds a marker with the place's location and information" do
        controller.
          should_receive(:render_to_string).
          with(:partial => "places/small_bubble", :locals => { :place => place }).
          and_return(bubble_content)
        GrbMarker.
          should_receive(:new).
          with([place.latitude, place.longitude], :title => place.name, :info_window => bubble_content).
          and_return(place_marker)
        subject
      end
    
      it "adds the place marker to the map" do
        map.should_receive(:overlay_init).with(place_marker)
        subject
      end
    end
    
    context "when place does not have a location" do
      let(:location) { nil }
      it "does not build a new map" do
        GMap.should_not_receive(:new)
        subject
      end
    end
  end
  
  it "#to_html is delegated to map" do
    map.should_receive(:to_html).with(:no_load => true, :no_script_tag => true).and_return("map_to_html")
    result = subject.to_html.gsub(/[\n\t]/, ' ').gsub(/\s+/, ' ')
    result.should have_tag("script", :text => " MapController.init(function () { map_to_html; return map; }); " )
  end
  
  describe "#div" do
    context "when place has location" do
      it "is delegated to map" do
        map.should_receive(:div).with(:height => "55px").and_return("some html")
        subject.div(:height => "55px").should == "some html"
      end
    end
    
    context "when place does not have location" do
      let(:location) { nil }
      
      it "renders a div with the mappable's dom_id" do
        subject.div.should have_tag("div##{dom_id(place, :map)}")
      end
    end
  end
  
  describe "#to_html_with_header " do
    context "when place has location" do
      it "returns the GMap.header and the map script code" do
        subject.should_receive(:to_html).and_return("<script></script>")
        GMap.should_receive(:header).and_return("GMap.header.content")
        subject.to_html_with_header.should == "GMap.header.content<script></script>"
      end
    end
    context "when the place does not have a location" do
      let(:location) { nil }
      
      its(:to_html_with_header) { should be_nil }
    end

  end
end
