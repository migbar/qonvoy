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
#

require 'spec_helper'

describe Place do
  should_validate_presence_of :name
  
  describe "#missing_information?" do
    it "is true if address is blank" do
      place = Factory.build(:place, :address => "")
      place.should be_missing_information
    end
  end
end
