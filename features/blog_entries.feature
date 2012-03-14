Feature: Blog Entries

Background:
	Given 1 blog
	
Scenario: View a list of blog entries
	Given 2 blog entries
	When I go to their blog's page
	Then I should see a list of blog entries
	And I should see the recent posts widget for that blog

Scenario: See the article meta for each entry
	Given 2 blog entries
	When I go to their blog's page
	Then I should see article meta for each entry

Scenario: See related content and links
	Given 1 blog entry
	Given the blog entry has 2 backward related articles
	And the blog entry has 2 forward related articles
	And the blog entry has 2 related links
	When I go to that blog entry's page
	Then I should see 4 related articles
	And I should see 2 related links