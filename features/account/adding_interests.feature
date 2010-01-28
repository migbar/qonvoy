Feature: Adding interests
  In order to be better connected to my community
  As a user
  I want to share my interests

  Scenario: Specifying my interests when I register
    Given I register as "twitter_guy" using Twitter
     Then I should be on my profile page
      And I should see "Specify your interests"
     When I fill in the following:
       | Location   | New York |
       | interest_0 | bdd      |
       | interest_1 | ruby     |
       | interest_2 | jquery   |
       | interest_3 | rails    |
       | interest_4 | webdev   |
      And I press "Save my interests"
     Then I should see "Saved your interests"