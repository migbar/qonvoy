Feature: Updating social graph
  In order to keep a users social graph up to date
  As RatingBird 
  I want to fetch and update the user's social networks 

@wip
Scenario: updating graph from Twitter
   Given the following Twitter users are registered with RatingBird
     | twitter_guy |
     | adam        |
     | barack      |
   And "twitter_guy" is following the following Twitter users:
     | adam    |
     | barack  |
     | Charlie |
     | Dave    |
      
    When the social graph is updated for "twitter_guy"
    Then "twitter_guy" should following these RatingBird users:
    | adam   |
    | barack |

  