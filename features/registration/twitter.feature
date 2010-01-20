Feature: Oauth
  In order to easily access Qonvoy
  As a Twitter user
  I want to be able to register and log in using my Twitter account

  Scenario: Registering with Qonvoy using Twitter
    Given a Twitter user "twitter_guy" that is not registered with Qonvoy
      And I am on the registration page
     When I press "Register using Twitter"
     Then I should see "Thank you for registering twitter_guy"
