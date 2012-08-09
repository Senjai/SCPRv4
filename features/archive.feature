Feature: Archive

Scenario: See the archive page with a date
	Given there was some content generated on a past date
	When I go to the archive page for that date
	Then I should see the archived content

Scenario: Visit the archive page without a date
	When I go to the archive page with no date
	Then I should only see the select form

Scenario: Choose a date from the select and see that page
	Given there was some content generated on a past date
	When I go to the home page
	And I select a past date from the archive select
	Then I should be on the archive page for that date
	And I should see the archived content
