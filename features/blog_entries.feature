Feature: Blog Entries

Background:
	Given 1 blog
	
Scenario: View a list of blog entries
	Given 2 blog entries
	When I go to the blog's page
	Then I should see a list of blog entries

Scenario: See the article meta for each entry
	Given 2 blog entries
	When I go to the blog's page
	Then I should see article meta for each entry