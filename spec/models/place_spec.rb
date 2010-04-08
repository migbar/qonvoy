# == Schema Information
#
# Table name: places
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     indexed
#  address    :text
#  latitude   :decimal(10, 8)
#  longitude  :decimal(12, 8)
#  created_at :datetime
#  updated_at :datetime
#  z_food     :integer(4)
#  z_decor    :integer(4)
#  z_service  :integer(4)
#  z_price    :integer(4)
#

require 'spec_helper'

describe Place do
  should_validate_presence_of :name
  
  context "associations" do
    should_have_many :dishes
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
  
  it "#rating returns the z_food value divided by 3" do
    Place.new(:z_food => 27).rating.should == 9
    Place.new(:z_food => 24).rating.should == 8
  end
end
