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

class Place < ActiveRecord::Base
  validates_presence_of :name
  has_many :dishes
  has_one :location, :dependent => :destroy
  delegate :latitude, :longitude, :bounds, :sw_bounds, :ne_bounds, :to => :location, :allow_nil => true
  
  def missing_information?
    address.blank?
  end
  
  def from_zagat?
    !z_id.nil?
  end
  
  def geocode
    return if address.blank?
    geoloc = Geokit::Geocoders::GoogleGeocoder.geocode(address_without_intersection)
    
    Location.destroy(location.id) if location
    
    create_location(
      {
        :bounds => {
          :ne => { :latitude => geoloc.suggested_bounds.ne.lat, :longitude => geoloc.suggested_bounds.ne.lng },
          :sw => { :latitude => geoloc.suggested_bounds.sw.lat, :longitude => geoloc.suggested_bounds.sw.lng } },
        :latitude       => geoloc.lat,
        :longitude      => geoloc.lng,
        :city           => geoloc.city,
        :state          => geoloc.state,
        :province       => geoloc.province,
        :full_address   => geoloc.full_address,
        :district       => geoloc.district,
        :country        => geoloc.country,
        :country_code   => geoloc.country_code,
        :provider       => geoloc.provider,
        :precision      => geoloc.precision,
        :accuracy       => geoloc.accuracy,
        :zip            => geoloc.zip,
        :street_address => geoloc.street_address 
      }
    )
  end
  
  def to_s
    name
  end
  
  def rating
    z_food / 3.0 if z_food
  end
  
  def has_location?
    !location.blank?
  end
  
  private 
    def address_without_intersection
      address.gsub(/\(([^\)]*)\)/, '').gsub(/\s+/, ' ')
    end
end
