Feature: Promotions
	In order to promote links, content, and features around the site
	As an Editor
	I want to create a promotion and include it on pages

Scenario: Attempt to create an invalid promotion
	Given I am logged in
	When I go to "new admin promotion"
	And I leave the fields empty
	And I submit the "new promotion" form
	Then I should see the "new promotion" form
	And there should be 0 promotions
	And I should be notified of errors

Scenario: Create a valid promotion
	Given I am logged in
	When I go to "new admin promotion"
	And I fill in all of the required fields with valid information
	And I submit the "new promotion" form
	Then I should be on the edit page for that record
	And I should see a success message
	And there should be 1 promotion

Scenario: Edit a promotion
	Given 1 promotion
	And I am logged in
	When I go to edit that promotion
	And I update all of the required fields with valid information
	And I submit the "edit promotion" form
	Then I should be on the edit page for that record
	Then I should see a success message
	And the promotion's attributes should be updated 
