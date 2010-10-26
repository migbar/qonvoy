Feature: Adding interests
  In order to be better connected to my community
  As a user
  I want to share my interests
  
  @javascript @wip
  Scenario: Specifying my interests when I register
    Given I register as "twitter_guy" using Twitter
     Then I should be on my profile page
      And I should see "Specify your interests"
  
  @javascript @wip @show-page
  Scenario: Filling in my interests on the profile page
    Given I am a logged in as the Twitter user "twitter_guy"
      And I am on my profile page
     When I select the following interests:
        | interest     | fill_in   | click     |
        | Cuisine      | italian   | french    |
        | Neighborhood | UES       | LWS       |
      And I press "Save my interests"
     Then my interest lists should be:
        | interest     | list                 |
        | cuisine      | italian, french      |
        | neighborhood | UES, LWS             |
