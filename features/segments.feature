Feature: Segments

Background: 
	Given there is 1 kpcc program
	And the program has 1 segment

Scenario: View a segment
	When I go to that segment's page
	Then I should see the segment's information 
	And I should see article meta for the segment
	And I should see a comments section
	And I should see the segment's primary asset
	
Scenario: See related content
	Given the segment has 2 backward related articles
	And the segment has 2 forward related articles
	When I go to that segment's page
	Then I should see 4 related articles
	
Scenario: See related links
	Given the segment has 2 related links
	When I go to that segment's page 
	Then I should see 2 related links