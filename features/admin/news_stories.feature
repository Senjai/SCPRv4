Feature: News Stories

Scenario: Attempt to Create an invalid news story
	When I go to "new admin news story"
	And I do not fill in the required fields
	And I submit the "new news story" form
	Then I should see the "new news story" form
	And I should be notified of errors
	
Scenario: Create a valid news story
	When I go to "new admin news story"
	And I fill in all of the required fields with valid information
	And I submit the "new news story" form
	Then I should be on "admin news stories"
	And I should see a success message
