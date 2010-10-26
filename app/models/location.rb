# == Schema Information
#
# Table name: locations
#
#  id             :integer(11)     not null, primary key
#  provider       :string(255)
#  zip            :string(255)
#  latitude       :decimal(10, 8)
#  longitude      :decimal(12, 8)
#  district       :string(255)
#  state          :string(255)
#  province       :string(255)
#  country        :string(255)
#  city           :string(255)
#  street_address :string(255)
#  full_address   :string(255)
#  country_code   :string(255)
#  accuracy       :integer(11)
#  precision      :string(255)
#  bounds         :text
#  place_id       :integer(11)     indexed
#  created_at     :datetime
#  updated_at     :datetime
#

class Location < ActiveRecord::Base
  belongs_to :place
  serialize :bounds, Hash    
  attr_accessor :json_bounds    
  
  def sw_bounds
    bounds.symbolize_keys[:sw].symbolize_keys
  end

  def ne_bounds
    bounds.symbolize_keys[:ne].symbolize_keys
  end
  
  # def json_bounds=(json)
  #   self.bounds = JSON.parse(json)
  # end  
end
