Feature: Flatpages

Scenario: View a flatpage with default options
	Given a flatpage with the following attributes:
	 | url    | title | content      | show_sidebar | render_as_template |
	 | /hello | Hello | Hello, World | 1 			| 0					 |
	
	When I go to that flatpage's url
	Then I should see the flatpage content
	And I should see the sidebar

Scenario: View a flatpage with no sidebar
	Given a flatpage with the following attributes:
	 | url    | title | content      | show_sidebar |
	 | /hello | Hello | Hello, World | 0 			|
	
	When I go to that flatpage's url
	And I should not see the sidebar

Scenario: View a flatpage with no layout
	Given a flatpage with the following attributes:
	 | url    | title | content      | render_as_template |
	 | /hello | Hello | Hello, World | 1				  |

	When I go to that flatpage's url
	And I should only see the flatpage content