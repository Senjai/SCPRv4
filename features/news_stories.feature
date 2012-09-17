Feature: News Stories

Background:
	Given I am logged in

Scenario: Attempt to Create an invalid news story
	When I go to "new admin news story"
	And I leave the fields empty
	And I mark the status as "Published"
	And I submit the "new news story" form
	Then I should see the "new news story" form
	And I should be notified of errors
	
Scenario: Create a valid news story
	When I go to "new admin news story"
	And I fill in all of the required fields with valid information
	And I mark the status as "Published"
	And I submit the "new news story" form
	Then I should be on "admin news stories"
	And I should see a success message
	And there should be 1 news story
	
Scenario: Edit a news story
	Given 1 news story
	When I go to edit that news story
	And I update all of the required fields with valid information
	And I submit the "edit news story" form
	Then I should be on "admin news stories"
	And I should see a success message
	And the news story's attributes should be updated

