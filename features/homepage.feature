Feature: Homepage

Scenario: See the homepage missed it bucket if there is one
	Given a homepage with the following attributes:
	 | missed_it_bucket[contents_count] |
	 | 3                    		 	|
	
	When I go to the home page
	Then I should see a missed it bucket
	And the missed it bucket should have 3 items in it
	
Scenario: Do not show a missed it bucket if the homepage doesn't have one
	Given a homepage with the following attributes:
	 | missed_it_bucket_id |
	 |                     |
	
	When I go to the home page
	Then I should not see a missed it bucket
	
Scenario: Do not show the missed it bucket if there is no content in it
	Given a homepage with the following attributes:
	 | missed_it_bucket[contents_count] |
	 | 0                                |
	
	When I go to the home page
	Then I should not see a missed it bucket