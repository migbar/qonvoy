# == Schema Information
#
# Table name: dishes
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)      indexed => [name], indexed
#  name       :string(255)     indexed, indexed => [place_id]
#  rating     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Dish do
  context "associations" do
    should_belong_to :place
    should_have_many :ratings
  end
  
  describe "#add_rating" do
    before(:each) do
      @dish = Factory.create(:dish, :rating => 50)
      @dish.stub(:save!)
      Factory.create(:rating, :value => 50, :dish => @dish)
      @rating = mock_model(Rating)
    end
    
    it "creates a new Rating with a normalized value to an internal scale of 100" do
      Rating.should_receive(:normalize).with("7", "10").and_return(70)
      @dish.ratings.should_receive(:create).with(:value => 70).and_return(@rating)
      @dish.add_rating("7", "10").should == @rating
    end
    
    it "updates the cached rating" do
      @dish.add_rating("7", "10")
      @dish.rating.should == 6
    end
    
    it "saves the dish" do
      @dish.should_receive(:save!)
      @dish.add_rating("7", "10")
    end
  end
end

