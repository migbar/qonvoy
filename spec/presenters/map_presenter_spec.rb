require 'spec_helper'

describe MapPresenter do
  include ActionView::Helpers::RecordIdentificationHelper
  
  subject { MapPresenter.new(place, :controller => controller) }
  
  let(:place) { Factory.create(:place) }
  let(:map) { mock(GMap).as_null_object }
  let(:controller) { mock("Controller", :render_to_string => bubble_content) }
  let(:place_marker) { mock(GMarker) }
  let(:bubble_content) { "bubble content" }
  
  before(:each) do
    GMap.stub(:new => map)
    GMarker.stub(:new => place_marker)
  end
  
  describe "#new" do
    it "builds a new map with the dom_id for the place" do
      GMap.should_receive(:new).with(dom_id(place, :map)).and_return(map)
      subject
    end
    
    it "inits the controls on the map" do
      map.should_receive(:control_init).with({:large_map => false, :small_map => true, :scale => true})
      subject
    end
    
    it "centers and zooms the map to the mappable location" do
      map.should_receive(:center_zoom_init).with([place.latitude, place.longitude], 13)
      subject
    end
    
    it "builds a marker with the place's location and information" do
      controller.
        should_receive(:render_to_string).
        with(:partial => "places/small_bubble", :locals => { :place => place }).
        and_return(bubble_content)
      GMarker.
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
  
  it "#to_html is delegated to map" do
    map.should_receive(:to_html).and_return("some html")
    subject.to_html.should == "some html"
  end
  
  it "#di is delegated to map" do
    map.should_receive(:div).with(:height => "55px").and_return("some html")
    subject.div(:height => "55px").should == "some html"
  end
  
  it "#to_html_with_header returns the GMap.header and the map script code" do
    map.should_receive(:to_html).and_return("<script></script>")
    GMap.should_receive(:header).and_return("GMap.header.content")
    subject.to_html_with_header.should == "GMap.header.content<script></script>"
  end
end
