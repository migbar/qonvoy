# == Schema Information
#
# Table name: statuses
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)      indexed
#  sender_screen_name :string(255)
#  sender_id          :integer(8)
#  body               :string(1000)
#  kind               :string(40)
#  status_created_at  :datetime
#  message_id         :integer(8)      indexed
#  raw                :text
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Status do
  include ActionController::UrlWriter

  context "associations" do
    should_belong_to :user
  end
  
  describe "#create_and_process" do
    before(:each) do
      @status = Factory.build(:status)
      @status.stub(:process)
      Status.stub(:create!).and_return(@status)
    end
    
    it "creates the status with the specified options" do
      Status.should_receive(:create!).with(:body => "Blah").and_return(@status)
      Status.create_and_process(:body => "Blah")
    end
    
    it "processes the status" do
      @status.should_receive(:process)
      Status.create_and_process(:body => "Blah")
    end
  end
  describe "#process" do
    before(:each) do
      @status = Factory.build(:dm_status, :body => "Awesome Shrimp Noodle Soup from Nobu - 8.5 out of 10.0")
      @parsed_hash = { :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8.5", :scale => "10", :type => "rating" }
      StatusParser.stub(:parse).and_return(@parsed_hash)
      @place = stub_model(Place, :name => @parsed_hash[:place], :missing_information? => false)
      Place.stub(:find_or_create_by_name).and_return(@place)
      @dish = mock_model(Dish, :add_rating => true)
      @place.dishes.stub(:find_or_create_by_name).and_return(@dish)
    end
    it "parses the status" do
      # d ratingbird Awesome sweet and sour Shrimp Noodle soup! 8.5 out of 10.0 
      # d ratingbird dish: .... place: ... rating: ...(scale?)
      # d ratingbird (Just had) Shrimp Noodle Soup [from|at] nobu [:-]? 8 out of 10
      # Parser.parse("Just had Shrimp Noodle Soup at nobu - 8.5 out of 10").should == 
      # { :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8.5", :scale => "10", :type => "rating" }
      # Parser.connect /(a) blah (b) and (c)/, {:scale => "$1", :rating => "$2", :type => "rating"}
      # case parsed_status[:type]
      # when "rating":
      # d ratingbird I want Noodle Soup
      
      StatusParser.should_receive(:parse).with(@status.body).and_return(@parsed_hash)
      @status.process
    end
    
    it "replies to the user with a link to a resolution page on parse failure" do
      pending
      StatusParser.should_receive(:parse).with(@status.body).and_return({})
    end
    
    it "finds or creates a place" do
      Place.should_receive(:find_or_create_by_name).with("Nobu").and_return(@place)
      @status.process
    end
    
    context "place is missing information" do
      before(:each) do
        @place.should_receive(:missing_information?).and_return(true)
        @tweet = "@#{@status.sender_screen_name} We don't know much about #{@place.name} yet. Could you help out? #{edit_place_url(@place, :host => Settings.host)}"
      end
      
      it "sends the tweet to the sender of the DM" do
        RatingBird.should_receive(:update).with(@tweet)
        @status.process
      end
    end
    
    it "finds or creates the rated dish within the place" do
      @place.dishes.should_receive(:find_or_create_by_name).with(@parsed_hash[:dish]).and_return(@dish)
      @status.process
    end
    
    it "rates the dish according to the scale" do
      @dish.should_receive(:add_rating).with(@parsed_hash[:rating], @parsed_hash[:scale])
      @status.process
    end
    
    it "tweets out the user's rating on their behalf" do
      pending
    end
  end
end
