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
#  dish_id            :integer(4)      indexed
#  place_id           :integer(4)      indexed
#  rating_id          :integer(4)
#

require 'spec_helper'

describe Status do
  include ActionController::UrlWriter

  context "associations" do
    should_belong_to :user
    should_belong_to :dish
    should_belong_to :place
    should_belong_to :rating
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
      @user = mock_model(User, :update_status_with_rating => nil)
      User.stub(:find_by_twitter_uid).and_return(@user)
    end
    
    context "successfully parsing the status" do
      before(:each) do
        @parsed_hash = { :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8.5", :scale => "10", :type => :rating }
        StatusParser.stub(:parse).and_return(@parsed_hash)
        @place = stub_model(Place, :name => @parsed_hash[:place], :missing_information? => false)
        Place.stub(:find_or_create_by_name).and_return(@place)
        @rating = mock_model(Rating)
        @dish = mock_model(Dish, :add_rating => @rating)
        @place.dishes.stub(:find_or_create_by_name).and_return(@dish)
      end
      
      it "finds the user by Twitter ID and assigns it to the status" do
        User.should_receive(:find_by_twitter_uid).with(@status.sender_id).and_return(@user)
        @status.process
        @status.user.should == @user
      end
      
      it "parses the status" do
        StatusParser.should_receive(:parse).with(@status.body).and_return(@parsed_hash)
        @status.process
      end
      
      it "checks the required attributes for rating" do
        @status.should_receive(:check_rating_options).with(@parsed_hash).and_return(true)
        @status.process
      end
    
      it "finds or creates a place and assigns it to the status" do
        Place.should_receive(:find_or_create_by_name).with("Nobu").and_return(@place)
        @status.process
        @status.place.should == @place
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
    
      it "finds or creates the dish within the place and assigns it to the status" do
        @place.dishes.should_receive(:find_or_create_by_name).with(@parsed_hash[:dish]).and_return(@dish)
        @status.process
        @status.dish.should == @dish
      end
    
      it "adds a rating for the dish in the proper scale and assigns it to the status" do
        @dish.should_receive(:add_rating).with(@parsed_hash[:rating], @parsed_hash[:scale]).and_return(@rating)
        @status.process
        @status.rating.should == @rating
      end
    
      it "tells the user to update their status with the rating" do
        @user.should_receive(:update_status_with_rating).with(@status)
        @status.process
      end
    
      it "saves the status" do
        @status.should_receive(:save!)
        @status.process
      end
    end

    context "failing to parse the status" do
      before(:each) do
        @status.save!
        @parsed_hash = { :dish => nil, :type => :rating }
        StatusParser.stub(:parse).and_return(@parsed_hash)
        @status.stub(:check_rating_options).and_return(false)
        @tweet = "@#{@status.sender_screen_name} We could not understand what you meant. Could you help out? #{status_url(@status, :host => Settings.host)}"
        RatingBird.stub(:update)
      end
      
      it "finds the user by Twitter ID and assigns it to the status" do
        User.should_receive(:find_by_twitter_uid).with(@status.sender_id).and_return(@user)
        @status.process
        @status.user.should == @user
      end
    
      it "parses the status" do
        StatusParser.should_receive(:parse).with(@status.body).and_return(@parsed_hash)
        @status.process
      end
    
      it "checks the required options for rating" do
        @status.should_receive(:check_rating_options).with(@parsed_hash).and_return(false)
        @status.process
      end
      
      it "sends a tweet to the sender of the DM, asking them to clarify their status" do
        RatingBird.should_receive(:update).with(@tweet)
        @status.process
      end
      
      it "sends a tweet to the sender of the DM, on total failure to parse -- :type option is unknown" do
        StatusParser.should_receive(:parse).with(@status.body).and_return(@parsed_hash.merge(:type => nil))
        RatingBird.should_receive(:update).with(@tweet)
        @status.process
      end
      
      it "saves the status" do
        @status.should_receive(:save!)
        @status.process
      end
    end
  end
  
  describe "#check_rating_options" do
    before(:each) do
      @status = Factory.build(:dm_status)
      @valid_rating_options = {:dish => "Shrimp Noodle Soup", :place => "Noby", :rating => "8.5"}
    end
    
    it "is true with valid rating options" do
      @status.check_rating_options(@valid_rating_options).should be_true
    end
    
    [:place, :dish, :rating].each do |key|
      it "returns false if #{key} is not set" do
        @status.check_rating_options(@valid_rating_options.merge(key => nil)).should be_false
      end
    end
  end
end
