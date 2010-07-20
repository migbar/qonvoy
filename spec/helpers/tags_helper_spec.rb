require 'spec_helper'

describe TagsHelper do
  describe "#all_interests" do
    subject { helper.all_interests 'cuisine' }
    
    before(:each) do
      Factory.create(:place, :cuisine_list => %w[chinese french italian])
      Factory.create(:place, :cuisine_list => %w[ethiopian chinese])
      Factory.create(:dish, :cuisine_list => %w[french])
    end
    
    it "returns a sorted list of all cuisines without duplicates" do
      should == %w[chinese ethiopian french italian]
    end
  end
end
