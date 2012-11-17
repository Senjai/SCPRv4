Feature: Episodes

Background:
  Given a kpcc program with the following attributes:
   | episode_count | episode[segment_count] | display_episodes | display_segments |
   | 2             | 2                      | 1                | 0                |
  
Scenario: View an episode
  When I go to an episode's page
  Then I should see a list of that episode's segments
  
Scenario: View an episode with no segments
  Given an episode with the following attributes:
   | segment_count |
   | 0             |

  When I go to that episode's page
  Then I should see that there is nothing to list
