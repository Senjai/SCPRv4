Feature: Segments

Scenario: View a segment
Given a kpcc program with the following attributes:
  | segment_count | segment[asset_count] |
  | 1             | 1                    |
  
  When I go to that segment's page
  Then I should see the segment's information 
  And I should see a comments section
  
Scenario: See related content and links
Given a kpcc program with the following attributes:
  | segment_count | segment[brel_count] | segment[frel_count] | segment[link_count] |
  | 1             | 2                   | 2                   | 2                   |
  
  When I go to that segment's page
  Then I should see 4 related articles
  And I should see 2 related links

Scenario: See other segments from the same episode
  Given a kpcc program with the following attributes:
   | episode_count | episode[segment_count] |
   | 1             | 4                      |
  
  When I go to any segment's page
  Then I should see an "other segments" section
  And that section should have 3 items
  And that section should not have the current segment listed
  
Scenario: See other segments from the same program when no episodes present
  Given a kpcc program with the following attributes:
   | episode_count | segment_count      |
   | 0             | 4                      |

  When I go to any segment's page
  Then I should see an "other segments" section
  And that section should have 3 items
  And that section should not have the current segment listed
