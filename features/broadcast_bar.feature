Feature: Broadcast Bar

Scenario: Display Episodes with segments
	Given a kpcc program with the following attributes:
	 | episode_count | episode[segment_count] | display_episodes | display_segments | slug    |
	 | 1             | 3                      | 1                | 0                | airtalk |

	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should see a headshot in the broadcast bar
	And I should see the episode guide
	
Scenario: Display Episodes without segments
	Given a kpcc program with the following attributes:
	 | episode_count | episode[segment_count] | display_episodes | display_segments | slug    |
	 | 1             | 0                     | 1                | 0                 | airtalk |

	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should see a headshot in the broadcast bar
	And I should not see the episode guide

Scenario: Do not display episodes
	Given a kpcc program with the following attributes:
	 | episode_count | episode[segment_count] | display_episodes | display_segments | slug     |
	 | 1             | 2                      | 0                | 1                | filmweek |
	
	And the program is currently on
	When I go to the home page
	Then I should see the name of the program in the broadcast bar
	And I should not see the episode guide
