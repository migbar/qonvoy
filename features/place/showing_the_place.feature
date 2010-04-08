Feature: Showing the place
  In order to see the details of a restaurant
  As a User
  I want to see the show page for the place

  Background: 
    Given the following places exists:
      | place | name | address         | latitude  | longitude  | z_food |
      | nobu  | Nobu | 123 bleecker St | 40.771324 | -73.985887 | 24     |
    
  Scenario: rendering the place details on the show page
     Given the following dishes exist:
      | dish | name               | rating |place       |
      | sns  | Shrimp noodle soup | 75     |place "nobu"|
      | cfr  | Chicken fried rice | 60     |place "nobu"|
      | pb   | Pork Buns          | 85     |place "nobu"|
     And the following ratings exist:
      | rating | dish       | value   |
      | sns    | dish "sns" | 70      |
      | cfr    | dish "cfr" | 60      |
      | pb     | dish "pb"  | 90      |
     And the following statuses exist:
      | dish       | body         | rating       | 
      | dish "sns" | Awesome      | rating "sns" |
      | dish "cfr" | not so bad   | rating "cfr" |
      | dish "pb"  | The greatest | rating "pb"  |
    
     When I am on the show page for the place "Nobu"
     Then I should see the following within:
       | Nobu            | h2              |
       | 123 bleecker St | .place .address |
       | 8               | .place .rating  |
     
     And I should see the following dishes:
       | name               | rating | status       | status_rating |
       | Pork Buns          | 8.5    | The greatest | 9             |
       | Shrimp noodle soup | 7.5    | Awesome      | 7             |
       | Chicken fried rice | 6      | not so bad   | 6             |
  
@wip @javascript
  Scenario: rendering the map for the place on the show page
     When I am on the show page for the place "Nobu"
     Then I should see a map with a marker at "40.771324,-73.985887"
      And the marker should contain "Nobu"
  