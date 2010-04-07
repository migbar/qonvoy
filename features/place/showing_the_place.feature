Feature: Showing the place
  In order to see the details of a restaurant
  As a User
  I want to see the show page for the place

@wip
  Scenario: rendering the show page for the place
    Given the following places exists:
      | place | name | address         | latitude  | longitude  | z_food |
      | nobu  | Nobu | 123 bleecker St | 40.771324 | -73.985887 | 8.5 |
     And the following dishes exist:
      | dish | name               | rating |place "nobu"|
      | sns  | Shrimp noodle soup | 7.5    |place "nobu"|
      | cfr  | Chicken fried rice | 6      |place "nobu"|
      | pb   | Pork Buns          | 8.5    |place "nobu"|
     And the following ratings exist:
      | rating | dish       | rating |
      | sns    | dish "sns" | 7      |
      | cfr    | dish "cfr" | 6      |
      | pb     | dish "pb"  | 9      |
     And the following statuses exist:
      | dish       | body         | rating       |
      | dish "sns" | Awesome      | rating "sns" |
      | dish "cfr" | not so bad   | rating "cfr" |
      | dish "pb"  | The greatest | rating "pb"  |
    
     When I am on the show page for the place "Nobu"
     Then I should see the following within:
       | Nobu            | .place h1.name  |
       | 123 bleecker St | .place .address |
       | 8.5             | .place .rating  |
     
     And I should see the following dishes:
       | name               | rating | status       | status_rating |
       | Pork Buns          | 8.5    | The greatest | 9             |
       | Shrimp noodle soup | 7.5    | Awesome      | 7             |
       | Chicken fried rice | 6      | not so bad   | 6             |
       