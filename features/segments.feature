Feature: Segments

Background: 
	Given there is 1 kpcc program

Scenario: View a segment
	Given the program has 1 segment
	When I go to that segment's page
	Then I should see the segment's information
	Then I should see article meta for the segment