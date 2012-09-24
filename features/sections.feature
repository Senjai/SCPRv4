Feature: Sections
	In order to flexibly deliver a sub-section of content
	As an Editor
	I want to be able to build a page with includable modules and layout options

Scenario: Attempt to create an invalid section
	Given I am logged in
	When I go to "new admin section"
	And I leave the fields empty
	And I submit the "new section" form
	Then I should see the "new section" form
	And there should be 0 sections
	And I should be notified of errors

Scenario: Create a valid section
	Given I am logged in
	When I go to "new admin section"
	And I fill in all of the required fields with valid information
	And I submit the "new section" form
	Then I should be on the edit page for that record
	And I should see a success message
	And there should be 1 section
	
Scenario: Edit a section
	Given 1 section
	And I am logged in
	When I go to edit that section
	And I update all of the required fields with valid information
	And I submit the "edit section" form
	Then I should be on the edit page for that record
	Then I should see a success message
	And the section's attributes should be updated 

Scenario: View a section as XML
	Given 1 section
	When I go to that section's XML feed
	Then I should see the latest content

	