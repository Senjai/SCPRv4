Feature: Categories

Scenario: View a category page
	Given a category with the following attributes:
	 | category | is_news | slug |
	 | Food		| 0		  | food |
	
	When I go to that category's page
	Then I should see the category's title

Scenario: View a category page when a flatpage has the same url
	Given a category with the following attributes:
	 | category | is_news | slug |
	 | Food		| 0		  | food |
	
	And a flatpage with the following attributes:
	 | url    | title | content      |
	 | /food  | Food  | Hello, World |
	
	When I go to the category's page
	Then I should not see the flatpage content
	And I should see the category's title

