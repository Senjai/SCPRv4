Feature: Categories

Scenario: View a category page
	Given a category with the following attributes:
	 | category | is_news | slug |
	 | Food		| 0		  | food |
	
	When I go to that category's page
	Then I should see the category's title

