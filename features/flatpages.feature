Feature: Flatpages

Scenario: View a flatpage with default options
	Given a flatpage with the following attributes:
	 | url    | title | content      |
	 | /hello | Hello | Hello, World |
	
	When I go to that flatpage's url
	Then I should see the flatpage content
	And I should see the sidebar

Scenario: View a flatpage with no sidebar
	Given a flatpage with the following attributes:
	 | url    | title | content      | template	|
	 | /hello | Hello | Hello, World | full		|
	
	When I go to that flatpage's url
	And I should not see the sidebar

Scenario: View a flatpage with no layout
	Given a flatpage with the following attributes:
	 | url    | title | content      | template |
	 | /hello | Hello | Hello, World | none		|

	When I go to that flatpage's url
	And I should only see the flatpage content

Scenario: Redirect
	Given a flatpage with the following attributes:
	 | url        | redirect_url |
	 | /something | /            |
	
	When I go to that flatpage's url
	Then I should be redirected to the redirect url

Scenario: Flatpage paths overwrite most others
	Given a category with the following attributes:
	 | category | is_news | slug |
	 | Foodxx	| 0		  | food |

	And a flatpage with the following attributes:
	 | url     | title 	  | content      |
	 | /food/  | YumYums  | Hello, World |

	When I go to the flatpage's url
	Then I should see "Hello, World"
	And I should not see "Foodxx"
