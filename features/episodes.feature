Feature: Episodes

Background:
	Given there is 1 episodic-style kpcc program
	And the program has 2 episodes
	And each episode has 2 segments
	
Scenario: View an episode
	When I go to an episode's page
	Then I should see a list of that episode's segments
	And only the published segments should be displayed
	And the segments should be ordered by the segment order
	And I should see each segment's primary asset
	
Scenario: View an episode with no segments
	Given there is 1 episode with no segments
	When I go to that episode's page
	Then I should see that there is nothing to list
	