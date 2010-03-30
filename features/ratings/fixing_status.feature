Feature: Fixing status
  In order clarify my rating contribution 
  As a Ratingbird user
  I want edit my status
  
  Background:
    Given I am a logged in as the Twitter user "twitter_dude"
      And a status "smth" exists with body: "Something that can not be parsed", user: user "twitter_dude"

  Scenario: amending the status to a parsable format
    Given I navigate to the status edit page for status "smth"
     When I fill in "Status" with "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
      And I press "Parse"
     Then I should see "Shrimp Noodle Soup" within ".rating .dish"
      And I should see "Nobu" within ".rating .place"
      And I should see "8" within ".rating .rating"
      And I should see "10" within ".rating .scale"
      
     When I press "Accept"
     Then a status should exist with body: "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10", parsed: true
