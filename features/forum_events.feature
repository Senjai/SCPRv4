Feature: Forum Events

Scenario: No Events
	Given there are 0 upcoming forum events
	When I go to the forum page
	Then I should see 0 events
	And I should see that there is nothing to list

Scenario: See the closest 4 events
	Given there are 6 upcoming forum events
	When I go to the forum page
	Then I should see the 4 closest events

Scenario: See primary assets for each event
	Given the following events:
	 | etype |  asset_count |
	 | comm  |  1           |
	 | comm  |  1           |

	When I go to the forum page
	Then I should see each event's primary asset

Scenario: Don't show unpublished events
Given the following events:
	 | etype | is_published |
	 | comm  | 1            |
	 | comm  | 1            |
	 | comm  | 0            |
	 | comm  | 0            |

	When I go to the forum page
	Then I should see a list of 2 upcoming events
	And I should see 0 unpublished events

Scenario: Don't show past events in the "upcoming" section
	Given the following events:
	 | etype | starts_at     |
	 | comm  | tomorrow 2pm  |
	 | comm  | tomorrow 3pm  |
	 | comm  | yesterday 4pm |
	 | comm  | yesterday 5pm |

	When I go to the forum page
	Then I should see a list of 2 upcoming events
	And I should see 0 past events
	
Scenario: Feature the closest event
	Given there are 4 upcoming forum events
	When I go to the forum page
	Then I should see the closest event featured

Scenario: List other near-future events below the closest event
	Given there are 4 upcoming forum events
	When I go to the forum page
	Then I should see future events listed below the closest event
	And the closest event should not be in the list of future events
	
Scenario: See past archived events on the bottom of the events page
	Given the following events:
	 | etype | starts_at     |
	 | comm  | yesterday 2pm |
	 | comm  | yesterday 3pm |
	 | comm  | yesterday 4pm |
	 | comm  | yesterday 5pm |

	When I go to the forum page
	Then I should see a list of archived events in the archive strip