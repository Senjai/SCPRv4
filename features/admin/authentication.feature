Feature: Authentication

Background:
	Given I am an admin user

Scenario: Show login form
	Given I am logged out
	When I go to "admin login"
	Then I should see the "login" form
	And I should not be logged in
	
Scenario: Fill in incorrect information
	Given I am logged out
	When I go to "admin login"
	And I fill in the login fields with invalid information
	And I submit the "login" form
	Then I should see a failure message
	And I should see the "login" form
	And I should not be logged in
	
Scenario: Login to the admin
	Given I am logged out
	When I go to "admin login"
	And I fill in the login fields with valid information
	And I submit the "login" form
	Then I should see a success message
	And I should be on "admin root"
	
Scenario: Visit login page while already logged in
	Given I am logged in
	When I go to "admin login"
	Then I should be on "admin root"
	
Scenario: Logout
	Given I am logged in
	When I click "logout"
	Then I should see a success message
	And I should be on "admin login"
	And I should not be logged in