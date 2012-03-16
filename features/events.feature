Feature: Events

Scenario: See the closest 4 events on the events page
	Given there are 6 upcoming events
	When I go to the events page
	Then I should see the 4 closest events

Scenario: See primary assets for each events
	Given there are 4 upcoming events
	And each event has 1 asset
	When I go to the events page
	Then I should see each event's primary asset

Scenario: Don't show unpublished events
	Given there are 2 upcoming events
	And there are 2 unpublished events
	When I go to the events page
	Then I should see 2 upcoming events
	And I should not see any unpublished events

Scenario: Don't show past events in the "upcoming" section
	Given there are 2 upcoming events
	And there are 2 past events
	When I go to the events page
	And I'm looking at the "upcoming events" section
	Then I should see 2 upcoming events
	And I should not see any past events
	
Scenario: Feature the closest event
	Given there are 4 upcoming events
	When I go to the events page
	Then I should see the closest event featured

Scenario: List other near-future events below the closest event
	Given there are 4 upcoming events
	When I go to the events page
	Then I should see future events listed below the closest event
	And the closest event should not be in the list of future events
	
Scenario: See past archived events on the bottom of the events page
	Given there are 4 past events
	When I go to the events page
	Then I should see a list of archived events in the archive strip
	