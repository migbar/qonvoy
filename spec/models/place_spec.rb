# == Schema Information
#
# Table name: places
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     indexed
#  address    :text
#  created_at :datetime
#  updated_at :datetime
#  z_food     :integer(4)
#  z_decor    :integer(4)
#  z_service  :integer(4)
#  z_price    :integer(4)
#  z_id       :integer(4)      indexed
#  phone      :string(255)
#

require 'spec_helper'

describe Place do
  should_validate_presence_of :name
  
  context "associations" do
    should_have_many :dishes
    should_have_one :location
  end
  
  describe "#missing_information?" do
    it "is true if address is blank" do
      place = Factory.build(:place, :address => "")
      place.should be_missing_information
    end
  end
  
  it "#to_s returns the name" do
    Place.new(:name => "nobu").to_s.should == "nobu"
  end
  
  it  "delegates bounds to location" do
    place = Place.new(:location => Location.new)
    place.location.should_receive(:bounds).and_return({:ne => {}, :sw => {}})
    place.bounds.should == {:ne => {}, :sw => {}}
  end
  
  it  "delegates latitude to location" do
    place = Place.new(:location => Location.new)
    place.location.should_receive(:latitude).and_return(-73.87239)
    place.latitude.should == -73.87239
  end
  
  it  "delegates longitude to location" do
    place = Place.new(:location => Location.new)
    place.location.should_receive(:longitude).and_return(40.87239)
    place.longitude.should == 40.87239
  end             
  
  it "allows location to be nil for delegates" do
    place = Place.new
    %w[latitude longitude bounds sw_bounds ne_bounds].each do |msg|
      place.send(msg).should be_nil
    end
  end
  
  it "#rating returns the z_food value divided by 3, or nil if there is no z_food rating" do
    Place.new(:z_food => 27).rating.should == 9
    Place.new(:z_food => 24).rating.should == 8
    Place.new(:z_food => 26).rating.should be_close(8.66, 0.01)
    Place.new.rating.should be_nil
  end
  
  describe "#from_zagat?" do
    it "is true if z_id is set" do
      Factory.build(:zagat_place).should be_from_zagat
    end
    
    it "is false if z_id is not set" do
      Factory.build(:place).should_not be_from_zagat
    end
  end
  
  describe "#geocode" do
    context "zagat place" do
      subject { Factory.build :zagat_place, :address => '1 Central Park W. (bet. 60th & 61st Sts.) Manhattan, NY' }
      let(:geo_result) do
        mock(Geokit::GeoLoc,
          :provider         => "google",
          :zip              => "10023",
          :lng              => -73.123,
          :success          => true,
          :district         => "Manhattan",
          :lat              => 40.123,
          :province         => "New York",
          :state            => "NY",
          :country          => "USA",
          :city             => "New York",
          :full_address     => "W 61st St, New York, NY 10023, USA",
          :country_code     => "US",
          :street_address   => "W 61st St",
          :accuracy         => 6,
          :precision        => "zip+4",
          :suggested_bounds => suggested_bounds)
      end
      let(:suggested_bounds) {
        mock(Geokit::Bounds,
          :ne => mock(Geokit::LatLng, :lat => 1, :lng => 2),
          :sw => mock(Geokit::LatLng, :lat => 3, :lng => 4))
      }
      let(:location) { mock_model(Location) }
      
      before(:each) do
        Geokit::Geocoders::GoogleGeocoder.stub(:geocode => geo_result)
      end
      
      it "calls the geocode services with the addres with the intersection stripped out" do
        Geokit::Geocoders::GoogleGeocoder.
          should_receive(:geocode).
          with('1 Central Park W. Manhattan, NY').
          and_return(geo_result)

        subject.geocode
      end
      
      it "creates a new Location with options from the Geocoding result" do
        subject.should_receive(:create_location).with({
          :bounds => {
            :ne => { :latitude => suggested_bounds.ne.lat, :longitude => suggested_bounds.ne.lng },
            :sw => { :latitude => suggested_bounds.sw.lat, :longitude => suggested_bounds.sw.lng } },
          :latitude       => geo_result.lat,
          :longitude      => geo_result.lng,
          :city           => geo_result.city,
          :state          => geo_result.state,
          :province       => geo_result.province,
          :full_address   => geo_result.full_address,
          :district       => geo_result.district,
          :country        => geo_result.country,
          :country_code   => geo_result.country_code,
          :provider       => geo_result.provider,
          :precision      => geo_result.precision,
          :accuracy       => geo_result.accuracy,
          :zip            => geo_result.zip,
          :street_address => geo_result.street_address
        }).and_return(location)
        subject.geocode
      end
      
      context "with existing location" do
        subject { Factory.create(:zagat_place) }
        let(:original_location) { subject.location.id }
        
        it "destroys the existing location" do
          subject.location.id.should == original_location
          expect do
            subject.geocode
          end.to_not change { Location.count }
          
          subject.reload.location.id.should_not == original_location
          
          Location.exists?(:original_location).should be_false
        end
      end
      
    end
    
    context "user contributed" do
      subject { Factory.build :user_place, :address => '1 Central Park W. (bet. 60th & 61st Sts.) Manhattan, NY' }
    end
  end
end
