Feature: Adding interests
  In order to be better connected to my community
  As a user
  I want to share my interests
  
  Background:
    Given the following twitter users exist:
    | cuisine_list    | feature_list         | neighborhood_list | dish_type_list |
    | italian, french | Open Late, Fireplace | UES, LWS          | pasta, dessert |
  
  @javascript @wip
  Scenario: Specifying my interests when I register
    Given I register as "twitter_guy" using Twitter
     Then I should be on my profile page
      And I should see "Specify your interests"
  
  @javascript @wip @show_page
  Scenario: Filling in my interests on the profile page
    Given I am a logged in as the Twitter user "twitter_guy"
      And I am on my profile page
     When I select the following interests:
        | interest     | fill_in   | click     |
        | Cuisine      | italian   | french    |
        | Feature      | Open Late | Fireplace |
        | Neighborhood | UES       | LWS       |
        | Dish type    | pasta     | dessert   |
      And I press "Save my interests"
     Then my interest lists should be:
        | interest     | list                 |
        | cuisine      | italian, french      |
        | feature      | Open Late, Fireplace |
        | neighborhood | UES, LWS             |
        | dish_type    | pasta, dessert       |
     
     # When I fill in "Cuisine" with "italian"
     # Then "italian" should be selected in the "cuisine" interests panel
     # When I follow "french" within "#cuisine.interests"
     # Then the "Cuisine" field should contain "french"
