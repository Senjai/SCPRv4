Feature: Segments

Background: 
	Given a kpcc program with the following attributes:
	 | segment_count | segment[brel_count] | segment[frel_count] | segment[link_count] | segment[asset_count] |
	 | 1             | 2                   | 2                   | 2                   | 1                    |

Scenario: View a segment
	When I go to that segment's page
	Then I should see the segment's information 
	And I should see article meta
	And I should see a comments section
	And I should see the segment's primary asset
	
Scenario: See related content and links
	When I go to that segment's page
	Then I should see 4 related articles
	And I should see 2 related links
