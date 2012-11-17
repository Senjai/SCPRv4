Feature: Programs

Scenario: No Programs
  Given there are 0 kpcc programs
  And there are 0 other programs
  When I go to the programs page
  Then I should not see any programs

Scenario: View a KPCC Program's page
  Given there is 1 kpcc program
  When I go to the program's page
  Then I should see the program's information
  And I should not see a video
  
Scenario: View an Other Program's page
  Given there is 1 other program
  When I go to the program's page
  Then I should see the program's information
  And I shouldn't see anything about episodes

Scenario: See a program's segments
  Given a kpcc program with the following attributes:
   | display_segments | display_episodes | segment_count | segment[asset_count] |
   | 1                | 0                | 2             | 1                    |

  When I go to the program's page
  Then I should see a list of that program's segments

Scenario: See an episodic program's episodes
  Given a kpcc program with the following attributes:
   | display_segments | display_episodes | episode_count | episode[asset_count] |
   | 0                | 1                | 2             | 1                    |
  
  When I go to the program's page
  Then I should see a list of older episodes below the current episode
  
Scenario: See an episodic program's current episode
  Given a kpcc program with the following attributes:
   | display_segments | display_episodes | episode_count | episode[segment_count] | episode[asset_count] |
   | 0                | 1                | 2             | 2                      | 1                    |

  When I go to the program's page
  Then I should see the current episode's information
  And I should see a list of the current episode's segments

Scenario: See a video player if the program has a dedicated Brightcove player
  Given a kpcc program with the following attributes:
   | title     | video_player |
   | Cool Show | 99999        |
  
  When I go to that program's page
  Then I should see a video

Scenario: Archive
  Given a kpcc program with the following attributes:
  | episode_count | episode[air_date] | display_episodes |
  | 1             | 2011-05-22        | true             |
  
  When I go to that program's page
  And I select the date for that episode in the archive select
  And I submit the "archive date select" form
  Then I should be on the episode's page

Scenario: Archive episode doesn't exist
  Given a kpcc program with the following attributes:
  | episode_count | episode[air_date] | display_episodes |
  | 1             | 2011-05-22        | true             |
  
  When I go to that program's page
  And I select a date that doesn't exist for an episode in the archive select
  And I submit the "archive date select" form
  Then I should be on the program's page

Scenario: No Archive feature if the program doesn't display episodes
  Given a kpcc program with the following attributes:
  | display_episodes |
  | false            |
  
  Then I should not see the archive select
