Feature: Blogs

Scenario: List News Blogs
	Given 2 news blogs
	When I go to the blogs page
	Then I should see 2 blogs listed in the News section

Scenario: See latest entry for a local blog
	Given 1 blog
	And 2 entries for that blog
	When I go to the blogs page
	Then I should see the latest entry for that blog
	
Scenario: See latest entries for a remote blog
	Given 1 remote blog
	And the entries for it have been cached
	When I go to the blogs page
	Then I should see the latest entries for that blog

Scenario: Blog Teaser on Blogs Index page
	Given 1 blog
	When I go to the blogs page
	Then I should see that blog's teaser

Scenario: Local Blog
	Given 1 blog
	And 2 entries for that blog
	When I go to that blog's page
	Then I should see the blog's information
	And I should see the blog's entries listed