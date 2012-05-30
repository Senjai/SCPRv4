Feature: News Stories

Scenario: Create a news story
	When I go to the "new admin news story" page
	And I fill in all of the required fields with valid information
	Then I should be on the "admin news stories" page
	And I should see a success message
