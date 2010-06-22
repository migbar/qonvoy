Feature: Adding interests
  In order to be better connected to my community
  As a user
  I want to share my interests
  
  Background:
    Given a place exists with cuisine_list: "italian, french"
  
  @javascript @wip
  Scenario: Specifying my interests when I register
    Given I register as "twitter_guy" using Twitter
     Then I should be on my profile page
      And I should see "Specify your interests"
  
  @javascript @wip
  Scenario: Filling in my interests on the profile page
    Given I am a logged in as the Twitter user "twitter_guy"
      And I am on my profile page
     When I fill in "Cuisine" with "italian"
     Then "italian" should be selected in the "cuisine" interests panel
     When I follow "french" within "#cuisine.interests"
     Then the "Cuisine" field should contain "french"
     When I press "Save my interests"
     Then my cuisine_list should be "italian, french"
     
  # Scenario: Specifying my interests when I register
  #   Given I register as "twitter_guy" using Twitter
  #    Then I should be on my profile page
  #     And I should see "Specify your interests"
  #    When I fill in the following:
  #      | Location   | New York |
  #      | interest_0 | bdd      |
  #      | interest_1 | ruby     |
  #      | interest_2 | jquery   |
  #      | interest_3 | rails    |
  #      | interest_4 | webdev   |
  #     And I press "Save my interests"
  #    Then I should see "Saved your interests"