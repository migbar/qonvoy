Feature: Showing the place
  In order to see the details of a restaurant
  As a User
  I want to see the show page for the place

  Background: 
    Given the following locations exists:
      | location | latitude | longitude   | 
      | loc1     | 40.771324 | -73.985887 |  
     And the following places exists:
      | place | name | address         | z_food | location        |
      | nobu  | Nobu | 123 bleecker St | 24     | location "loc1" |
  
  Scenario: rendering the place details on the show page
     Given the following dishes exist:
      | dish | name               | rating |place       |
      | sns  | Shrimp noodle soup | 75     |place "nobu"|
      | cfr  | Chicken fried rice | 60     |place "nobu"|
      | pb   | Pork Buns          | 85     |place "nobu"|
     And the following ratings exist:
      | rating | dish       | value   |
      | sns1    | dish "sns" | 70      |
      | cfr1    | dish "cfr" | 60      |
      | pb1     | dish "pb"  | 90      |
      | sns2    | dish "sns" | 10      |
      | cfr2    | dish "cfr" | 10      |
      | pb2     | dish "pb"  | 10      |

     And the following statuses exist:
      | dish       | body            | rating        | processed_at        |
      | dish "sns" | Awesome         | rating "sns1" | 2010-03-23 10:04:54 |
      | dish "sns" | not-to-be-shown | rating "sns2" | 2010-03-23 09:04:54 |
      | dish "cfr" | not so bad      | rating "cfr1" | 2010-03-23 10:04:54 |
      | dish "cfr" | not-to-be-shown | rating "cfr2" | 2010-03-23 09:04:54 |
      | dish "pb"  | The greatest    | rating "pb1"  | 2010-03-23 10:04:54 |
      | dish "pb"  | not-to-be-shown | rating "pb2"  | 2010-03-23 09:04:54 |
    
     When I am on the show page for the place "Nobu"
     Then I should see the following within:
       | Nobu            | h2              |
       | 123 bleecker St | .place address |
       | 8               | .place .rating  |
     
     And I should see the following dishes:
       | name               | rating | status       | status_rating |
       | Pork Buns          | 8.5    | The greatest | 9.0           |
       | Shrimp noodle soup | 7.5    | Awesome      | 7.0           |
       | Chicken fried rice | 6.0    | not so bad   | 6.0           |
  
  @selenium
  Scenario: rendering the map for the place on the show page
     When I am on the show page for the place "Nobu"
      And I click the map marker at "40.771324,-73.985887"
      And the marker bubble should contain "Nobu" 
  