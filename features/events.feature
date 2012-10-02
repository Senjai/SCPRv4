Feature: Events

Background:
	Given events with the following attributes:
	 | headline      | etype | starts_at     | is_published |
	 | A Rad Event   | comm  | tomorrow 2pm  | 1            |
	 | A Cool Event  | comm  | tomorrow 1pm  | 1            |
	 | Future Event  | spon  | tomorrow 8pm  | 1            |
	 | Awesome Event | spon  | tomorrow 8pm  | 1            |
	 | Event Tile 1  | pick  | tomorrow 11am | 1            |
	 | Event Title 2 | pick  | tomorrow 11am | 1            |
	 | Unpub Event   | comm  | tomorrow      | 0            |
	 | Past event    | comm  | yesterday     | 1            |
	 | Past event 2  | pick  | yesterday     | 1            |

Scenario: View "All" events list
	When I go to the events page
	And I filter by "all"
	Then I should see a list of 6 upcoming events
	And I should see 0 past events
	And I should see 0 unpublished events

Scenario: View "Forum" events list
	When I go to the events page
	And I filter by "forum"
	Then I should see a list of 2 upcoming "forum" events
	And I should see 0 past events
	And I should see 0 unpublished events

Scenario: View "Sponsored" events list
	When I go to the events page
	And I filter by "sponsored"
	Then I should see a list of 2 upcoming "sponsored" events
	And I should see 0 past events
	And I should see 0 unpublished events

Scenario: Pagination
	Given there are 12 events
	When I go to the events page
	Then I should see 10 events
	And there should be pagination

Scenario: View an individual event without comments
	Given an event with the following attributes:
	 | headline  | show_comments |
	 | CFF Event | 0             |

	When I go to that event's page
	Then I should see "CFF Event"
	And I should see article meta
	And I should not see a comments section
	
Scenario: View an individual event with comments
	Given an event with the following attributes:
	 | headline  | show_comments |
	 | CFF Event | 1             |

	When I go to that event's page
	Then I should see a comments section

Scenario: Visit a page for an event that doesn't exist
	When I go to an event page for an event that doesn't exist
	Then I should be redirected to the events page

Scenario: RSVP link
	Given an event with the following attributes:
	 | rsvp_link       |
	 | http://scpr.org |

	When I go to that event's page
	Then I should see an RSVP link
	
Scenario: No RSVP link
	Given an event with the following attributes:
	 | rsvp_link |
	 |           |
	
	When I go to that event's page
	Then I should not see an RSVP link

Scenario: Show Map
	Given an event with the following attributes:
	 | show_map |
	 | 1        |
	
	When I go to that event's page
	Then I should see a map
	And I should see a link to open the map

Scenario: Do not show map
	Given an event with the following attributes:
	 | show_map |
	 | 0        |
	
	When I go to that event's page
	Then I should not see a map
	And I should not see a link to open the map

Scenario: See more upcoming events
	Given an event with the following attributes:
	 | etype | starts_at           |
	 | comm  | 30 minutes from now |

	When I go to that event's page
	Then I should see 2 more upcoming events listed
	And that event should not be in the upcoming events
	
Scenario: View detail for a past event
	Given an event with the following attributes:
	 | starts_at   | body                       | archive_description    | show_map | rsvp_link       |
	 | 2 weeks ago | This event will be awesome | This event was awesome | 1        | http://scpr.org |

	When I go to that event's page
	Then I should see that even has already occurred
	And I should not see an RSVP link
	And I should not see a link to open the map
	And I should not see a map
	And I should see "This event was awesome"
	And I should not see "This event will be awesome"
