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
      
    end
    it "finds or creates a place" do
      
    end
    it "finds or creates the rated dish within the place" do
      
    end
    it "rates the dish according to the scale" do
      
    end
    it "tweets out the user's rating on their behalf" do
      
    end
  end
end
