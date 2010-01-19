Feature: User Accounts
    In order to Ask and Answer questions
    As a user
    I want to register for an account, login and logout
 
    Scenario: Going to the registration page
      Given I am on the home page
      When I follow "Sign Up"
      Then I should see "Register for an account"