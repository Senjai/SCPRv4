Feature: Events

Background:
	Given the following events:
	 | title         | etype | starts_at     | is_published |
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

Scenario: Pagination
	Given there are 12 events
	When I go to the events page
	Then I should see 10 events
	And there should be pagination
