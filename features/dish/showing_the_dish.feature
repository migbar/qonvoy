Feature: Showing the dish
  In order to see the ratings relating to a dish 
  As a visitor
  I want see the dish show page

  Background:
    Given the following locations exists:
      | location | latitude | longitude   | 
      | loc1     | 40.771324 | -73.985887 |
    And the following places exists:
      | place | name | address         | z_food | location        |
      | nobu  | Nobu | 123 bleecker St | 24     | location "loc1" | 
    And the following dishes exist:
      | dish | name               | rating |place       |
      | sns  | Shrimp noodle soup | 75     |place "nobu"|

  Scenario: rendering the dish details and ratings
    Given the following dishes exist:
      | dish | name               | rating |place       |
      | cfr  | Chicken fried rice | 60     |place "nobu"|
      | pb   | Pork Buns          | 85     |place "nobu"|
    And the following ratings exist:
      | rating | dish       | value   |
      | rat1   | dish "sns" | 75      |
      | rat2   | dish "sns" | 60      |
      | rat3   | dish "sns" | 90      |
    And the following users exist:
      | user    | screen_name |
      | alice   | alice       |
      | bob     | bob         |
      | charlie | charlie     |
    And the following statuses exist:
      | dish       | body         | rating        | processed_at        | user           |
      | dish "sns" | Awesome      | rating "rat1" | 2010-03-23 09:04:54 | user "alice"   |
      | dish "sns" | not so bad   | rating "rat2" | 2010-03-23 08:04:54 | user "bob"     |
      | dish "sns" | The greatest | rating "rat3" | 2010-03-23 10:04:54 | user "charlie" |

    When I am on the show page for the dish "Shrimp noodle soup"
    Then I should see the following within:
      | Shrimp noodle soup | h2                      |
      | 7.5                | .dish .rating           |
      | Nobu               | #sidebar .place h3      |
      | 8                  | #sidebar .place .rating |
      | 123 bleecker St    | #sidebar .place address |
     And I should see the following ratings:
      | body         | rating | user    |
      | The greatest | 9.0    | charlie |
      | Awesome      | 7.5    | alice   |
      | not so bad   | 6.0    | bob     |
     And I should see the following dishes in the sidebar
      | name               | rating |
      | Pork Buns          | 8.5    |
      | Shrimp noodle soup | 7.5    |
      | Chicken fried rice | 6.0    |
      
  @selenium
  Scenario: rendering the map for the place on the dish show page
     When I am on the show page for the dish "Shrimp noodle soup"
      And I click the map marker at "40.771324,-73.985887"
      And the marker bubble should contain "Nobu"
     