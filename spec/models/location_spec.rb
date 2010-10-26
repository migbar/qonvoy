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

require 'spec_helper'

describe Location do
  
  should_belong_to :place
  
  describe "bounds" do
    subject      { Factory.create(:location, :bounds => bounds).reload }
    let(:bounds) { { :ne => { :latitude => 1, :longitude => 2 }, :sw => { :latitude => 3, :longitude => 4 } } }
    its(:bounds) { should == bounds }
  end
end
