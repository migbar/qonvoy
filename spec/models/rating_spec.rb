# == Schema Information
#
# Table name: ratings
#
#  id         :integer(4)      not null, primary key
#  dish_id    :integer(4)      indexed
#  value      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Rating do
  describe "associations" do
    should_belong_to :dish
  end
  
  describe ".normalize" do
    it "defaults the scale to 10 if not specified" do
      Rating.normalize(4).should == 40
      Rating.normalize(6, nil).should == 60
    end
    
    it "adjusts the rating value if the scale given is not 10" do
      Rating.normalize("27", "30").should == 90
      Rating.normalize(3, 5).should == 60
    end
    
    it "takes fractional arguments" do
      Rating.normalize("8.54").should == 85
      Rating.normalize("8.59").should == 86
    end
  end
end
