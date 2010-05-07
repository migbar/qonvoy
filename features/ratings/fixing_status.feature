Feature: Fixing status
  In order clarify my rating contribution 
  As a Ratingbird user
  I want edit my status
  
  Background:
    Given I am a logged in as the Twitter user "twitter_dude"
      And a status "smth" exists with body: "Something that can not be parsed", user: user "twitter_dude"

  Scenario: amending the status to a parsable format
    Given a place "nobu" exists with name: "Nobu", address: "123 Bleecker St"
     When I navigate to the status edit page for status "smth"
      And I fill in "Status" with "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
      And I press "Preview"
     Then I should see "Shrimp Noodle Soup" within ".rating .dish"
      And I should see "Nobu" within ".rating .place"
      And I should see "8" within ".rating .rating"
      And I should see "10" within ".rating .scale"
     When I press "Accept"
     Then a processed status should exist having body "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
      And I should be on the show page for the dish "Shrimp Noodle Soup"

  Scenario: amending the status to a parsable format when place is missing information
    Given I navigate to the status edit page for status "smth"
     When I fill in "Status" with "Awesome Shrimp Noodle Soup from Nobu - 8 out of 10"
      And I press "Preview"
      And I press "Accept"
     Then I should be on the edit page for the place "Nobu"

  Scenario: trying to amend an already processed status
    Given a place "nobu" exists
      And a dish "shrimp soup" exists with place: place "nobu", name: "shrimp soup"
      And a processed status "processed soup" exists with dish: dish "shrimp soup", place: place "nobu", user: user "twitter_dude"
     When I navigate to the status edit page for status "processed soup"
     Then I should be on the show page for the dish "shrimp soup"
  