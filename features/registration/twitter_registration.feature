Feature: Twitter Registration
  In order to easily access Qonvoy
  As a Twitter user
  I want to be able to register and log in using my Twitter account

  Scenario: Registering with Qonvoy using Twitter
    Given a Twitter user "twitter_guy" that is not registered with Qonvoy
      And I am on the home page
     When I press "Register using Twitter"
     Then I should see "Thank you for registering twitter_guy"

  Scenario: Denying Qonvoy access to Twitter
    Given a Twitter user that denies access to Qonvoy
     When I am on the home page
      And I press "Register using Twitter"
     Then I should see "You did not allow Qonvoy to use your Twitter account"

