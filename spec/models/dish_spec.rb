require 'spec_helper'

describe Dish do
  context "associations" do
    should_belong_to :place
  end
  
  describe "#add_rating" do
    before(:each) do
      @dish = Factory.create(:dish)
    end
    it "normalizes to an internal scale of 100" do
      
    end
  end
end
