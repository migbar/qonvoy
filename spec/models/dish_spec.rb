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
  subject { Factory.build(:dish, :name => "Shrimp noodle soup") }
  
  context "associations" do
    should_belong_to :place
    should_have_many :ratings
    should_have_many :statuses
    should_have_many :processed_statuses, :class_name => "Status", :conditions => "#{Status.table_name}.processed_at is not null"
    
    should_have_many :cuisines, :through => :cuisine_taggings
  end
  
  its(:to_s) { should eql("Shrimp noodle soup") }
  
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
  
  describe "#rating" do                                                     
    subject {Dish.new(:rating => _rating)} 
    
    context "when rating is set" do
      let(:_rating) { 85 }
      its(:rating)  { should == 8.5 }
    end
    
    context "when rating is nil" do
      let(:_rating) { nil }
      its(:rating)  { should be_nil }
    end
  end
  
  describe "#latest_status" do
    subject do
      returning(Dish.new) do |s|
        s.stub_chain(:statuses, :descend_by_processed_at, :first)
      end
    end
    let(:status) { mock_model(Status) }
    
    it "fetches the lastest status for the dish" do
      subject.statuses.descend_by_processed_at.should_receive(:first).and_return(status)
      subject.latest_status.should == status
    end
  end
end

