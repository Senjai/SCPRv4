Feature: Segments

Background: 
	Given there is 1 kpcc program

Scenario: View a segment
	Given the program has 1 segment
	When I go to that segment's page
	Then I should see the segment's information
	And I should see article meta for the segment
	And I should see a comments section
	And I should see the segment's primary asset
	And I should see related content
	And I should see related links