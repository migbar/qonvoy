Feature: Logout
  In order to protect my account
  As a Qonvoy user
  I want to be able to log out from Qonvoy
  
Scenario: logging out
  Given I am a logged in as the Twitter user "twitter_guy"
    And I am on the home page
   When I press "Log out"
   Then I should see "You have logged out"
    And I should be on the home page 
