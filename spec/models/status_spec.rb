# == Schema Information
#
# Table name: statuses
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)      indexed, indexed, indexed
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
#  processed_at       :datetime        indexed
#

require 'spec_helper'

describe Status do
  include ActionController::UrlWriter

  describe "associations" do
    should_belong_to :user
    should_belong_to :dish
    should_belong_to :place
    should_belong_to :rating
  end
  
  describe "named scopes" do
    describe "processed" do
      it "only finds the processed statuses" do
        expected = (1..3).map { Factory.create(:processed_status) }
        Factory.create(:status)
        Status.processed.should == expected
      end
    end
  end
  
  describe "#to_s" do
    subject { Status.new(:body => "blah blah") }
    its(:to_s) { should == "blah blah" }
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
        Status.should_receive(:check_rating_options).with(@parsed_hash).and_return(true)
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
        Status.stub(:check_rating_options).and_return(false)
        @tweet = "@#{@status.sender_screen_name} We could not understand what you meant. Could you help out? #{edit_status_url(@status, :host => Settings.host)}"
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
        Status.should_receive(:check_rating_options).with(@parsed_hash).and_return(false)
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
      @valid_rating_options = {:dish => "Shrimp Noodle Soup", :place => "Noby", :rating => "8.5"}
    end
    
    it "is true with valid rating options" do
      Status.check_rating_options(@valid_rating_options).should be_true
    end
    
    [:place, :dish, :rating].each do |key|
      it "returns false if #{key} is not set" do
        Status.check_rating_options(@valid_rating_options.merge(key => nil)).should be_false
      end
    end
  end
  
  it ".try_parsing tries to parse the status and returns the success flag and the parsing result as a pair" do
    StatusParser.should_receive(:parse).with("blah blah").and_return({ :rating => 5 })
    Status.should_receive(:check_rating_options).with({ :rating => 5 }).and_return(false)
    Status.try_parsing("blah blah").should == [false, { :rating => 5 }]    
  end
  
  describe "#process_rating" do
    before(:each) do
      @user = Factory.build(:twitter_user)
      @status = Factory.build(:dm_status, :user => @user, :body => "Awesome Shrimp Noodle Soup from Nobu - 8.5 out of 10.0")
      @parsed_hash = { :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8.5", :scale => "10", :type => :rating }
      @place = stub_model(Place, :name => @parsed_hash[:place], :missing_information? => false)
      Place.stub(:find_or_create_by_name).and_return(@place)
      @rating = mock_model(Rating)
      @dish = mock_model(Dish, :add_rating => @rating)
      @place.dishes.stub(:find_or_create_by_name).and_return(@dish)
    end
    
    it "finds or creates a place and assigns it to the status" do
      Place.should_receive(:find_or_create_by_name).with("Nobu").and_return(@place)
      @status.process_rating(@parsed_hash)
      @status.place.should == @place
    end
  
    context "place is missing information" do
      before(:each) do
        @place.should_receive(:missing_information?).and_return(true)
        @tweet = "@#{@status.sender_screen_name} We don't know much about #{@place.name} yet. Could you help out? #{edit_place_url(@place, :host => Settings.host)}"
      end
    
      it "sends the tweet asking for help to the sender of the DM" do
        RatingBird.should_receive(:update).with(@tweet)
        @status.process_rating(@parsed_hash)
      end
      
      it "does not ask for help if the ask_for_place_info flag is false" do
        RatingBird.should_not_receive(:update)
        @status.process_rating(@parsed_hash, false)
      end
    end
  
    it "finds or creates the dish within the place and assigns it to the status" do
      @place.dishes.should_receive(:find_or_create_by_name).with(@parsed_hash[:dish]).and_return(@dish)
      @status.process_rating(@parsed_hash)
      @status.dish.should == @dish
    end
  
    it "adds a rating for the dish in the proper scale and assigns it to the status" do
      @dish.should_receive(:add_rating).with(@parsed_hash[:rating], @parsed_hash[:scale]).and_return(@rating)
      @status.process_rating(@parsed_hash)
      @status.rating.should == @rating
    end
  
    it "tells the user to update their status with the rating" do
      @user.should_receive(:update_status_with_rating).with(@status)
      @status.process_rating(@parsed_hash)
    end
    
    it "sets the processed timestamp to Time.now" do
      now = Time.now
      Time.should_receive(:now).any_number_of_times.and_return(now)

      expect {
        @status.process_rating(@parsed_hash)
      }.to change { @status.processed_at }.from(nil).to(now)
    end
  end
  
  describe "#process_updated_status" do
    before(:each) do
      @status = Factory.build(:status, :body => "Awesome Shrimp Noodle Soup from Nobu - 8.5 out of 10.0") 
    end
    
    context "successful parsing" do
      before(:each) do
        Status.should_receive(:try_parsing).with(@status.body).and_return([true, { :rating => 8.5 }])
        @status.stub(:process_rating)
      end
      
      it "processes the rating" do
        @status.should_receive(:process_rating).with({ :rating => 8.5 }, false)
        @status.process_updated_status!
      end
      
      it "saves the status and returns true" do
        @status.should_receive(:save!).and_return(true)
        @status.process_updated_status!.should be_true
      end
    end
    
    context "failed parsing" do
      before(:each) do
        Status.should_receive(:try_parsing).with(@status.body).and_return([false, { }])
      end
      
      it "returns false" do
        @status.process_updated_status!.should be_false
      end
    end
  end
end
