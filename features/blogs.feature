Feature: Blogs

Scenario: List News Blogs
	Given 2 news blogs
	When I go to the blogs page
	Then I should see 2 blogs listed in the News section

Scenario: See latest entry for a blog
	Given a blog
	And 2 entries for that blog
	When I go to the blogs page
	Then  I should see the latest entry for that blog