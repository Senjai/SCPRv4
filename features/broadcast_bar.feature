Feature: Broadcast Bar

Scenario: Display Episodes with segments
	Given there is 1 episodic-style kpcc program
	And the program has 1 episode
	And the episode has 3 segments
	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should see a headshot in the broadcast bar
	And I should see the episode guide
	
Scenario: Display Episodes without segments
	Given there is 1 episodic-style kpcc program
	And the program has 1 episode
	And the episode has 0 segments
	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should see a headshot in the broadcast bar
	And I should not see the episode guide

Scenario: Do not display episodes
	Given there is 1 segment-style kpcc program
	And the program has 1 episode
	And the episode has 2 segments
	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should not see the episode guide
