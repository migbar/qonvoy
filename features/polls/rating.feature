Feature: Rating from Twitter
  In order to gauge people in my social graph's rating 
  As a ratingbird user
  I want to create a new place and submit a rating


  # d ratingbird Awesome sweet and sour Shrimp Noodle soup from Nobu - 8.5 out of 10.0 
  # d ratingbird dish: .... place: ... rating: ...(scale?)
  # d ratingbird (Just had) Shrimp Noodle Soup [from|at] nobu [:-]? 8 out of 10
  # Parser.parse("Just had Shrimp Noodle Soup at nobu - 8.5 out of 10").should == 
  # { :dish => "Shrimp Noodle Soup", :place => "Nobu", :rating => "8.5", :scale => "10", :type => "rating" }
  # Parser.connect /(a) blah (b) and (c)/, {:scale => "$1", :rating => "$2", :type => "rating"}
  # case parsed_status[:type]
  # when "rating":
  # d ratingbird I want Noodle Soup

  Scenario: Creating a place from Twitter
    Given I am a logged in as the Twitter user "twitter_dude"
     When I direct message Ratingbird with "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
       # 1. twitter_dude DMs ratingbird
       # 2. ratingbird fetches DMs (persisted for each user if user found)
       # 3. ratingbird processes DM (by DJ)
       # 3.1 parse out: place, rating, scale
       # 3.2 find or create place, dish
       # 3.2.1 DM user with query if new place
       # 3.3 rate dish
       # 3.4 tweet out rating for the user
     Then I should have a reply from "ratingbird" with "We don't know much about Nobu yet. Could you help out?"

      And a dish should exist with name: "Shrimp Noodle Soup"
      And the dish "Shrimp Noodle Soup" should have a rating of "8"
      And my Twitter status should be "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10 #ratingbird"
      
     When I click the first link in my status
     Then I should be on the ratings page for "Shrimp Noodle Soup"
