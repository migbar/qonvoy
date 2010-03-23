Feature: Rating from Twitter
  In order to gauge people in my social graph's rating 
  As a ratingbird user
  I want to create a new place and submit a rating
  
  Background:
    Given I am a logged in as the Twitter user "twitter_dude"
  
  Scenario: Rating a new dish at a new place from Twitter
    Given I direct message Ratingbird with "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
     Then I should have a reply from "ratingbird" with "We don't know much about Nobu yet. Could you help out?"
    
     When I click the first link in the reply
     Then I should be on the edit page for the place "Nobu"
     
      And a dish should exist with name: "Shrimp Noodle Soup"
      And the dish "Shrimp Noodle Soup" should have a rating of "8"
      And my Twitter status should be "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10 #ratingbird"
     When I click the first link in my status
     Then I should be on the ratings page for "Shrimp Noodle Soup"
  
  Scenario: Failing to parse a status
    Given I direct message Ratingbird with "Something that can not be parsed"
     Then I should have a reply from "ratingbird" with "We could not understand what you meant."
     When I click the first link in the reply
     Then I should be on the show page for the status "Something that can not be parsed"