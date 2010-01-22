Feature: Twitter Login
  In order to easily access Qonvoy
  As a Twitter user
  I want to be able to log in using my Twitter account

  Scenario: Logging in with Twitter
    Given a Twitter user "twitter_guy" registered with Qonvoy
      And I am on the home page
     When I press "Let me log in using Twitter"
     Then I should see "Welcome twitter_guy!"
     
  Scenario: Denying Qonvoy access to Twitter
    Given a Twitter user that denies access to Qonvoy
     When I am on the home page
      And I press "Let me log in using Twitter"
     Then I should see "You did not allow Qonvoy to use your Twitter account"
  