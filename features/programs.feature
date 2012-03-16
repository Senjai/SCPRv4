Feature: Programs

Scenario: No Programs
	Given there are 0 kpcc programs
	And there are 0 other programs
	When I go to the programs page
	Then I should not see any programs

Scenario: See the featured programs on the index page
	Given the following programs:
		| slug				| title						|
		| madeleine-brand	| The Madeleine Brand Show	|
		| airtalk			| Airtalk					|
		| patt-morrison		| Patt Morrison				|
		| offramp			| Off-Ramp					|
	When I go to the programs page
	Then I should see the featured programs in the correct order

Scenario Outline: View a Featured Program's page
	Given a program titled "<title>" with slug "<slug>"
	When I go to the program's page
	Then I should see the program's information
	Then I should see a headshot of the program's host
	
	Examples:
		| slug				| title						|
		| madeleine-brand	| The Madeleine Brand Show	|
		| airtalk			| Airtalk					|
		| patt-morrison		| Patt Morrison				|
		| offramp			| Off-Ramp					|
		
Scenario: View a KPCC Program's page
	Given there is 1 kpcc programs
	When I go to the program's page
	Then I should see the program's information
	
Scenario: View an Other Program's page
	Given there is 1 other program
	When I go to the program's page
	Then I should see the program's information
	And I shouldn't see anything about episodes

Scenario: View cached podcast feed for Other Program
	Given there is 1 other program with a podcast and no RSS
	And its feeds are cached
	When I go to the program's page
	Then I should see a list of that program's podcast entries
	And I should not see any RSS entries

Scenario: View cached RSS feed for Other Program
	Given there is 1 other program with an RSS and no podcast
	And its feeds are cached
	When I go to the program's page
	Then I should see a list of that program's RSS entries
	And I should not see any podcast entries

Scenario: View Other Program without rss or podcast
	Given there is 1 other program with no RSS and no podcast
	When I go to the program's page
	Then I should see that there is nothing to list
	
Scenario: See a program's segments
	Given there is 1 segment-style kpcc program
	And the program has 2 segments
	When I go to the program's page
	Then I should see a list of that program's segments
	And I should see each segment's primary asset

Scenario: See an episodic program's episodes
	Given there is 1 episodic-style kpcc program
	And the program has 2 episodes
	When I go to the program's page
	Then I should see a list of older episodes below the current episode
	And I should see each episode's primary asset
	
Scenario: See an episodic program's current episode
	Given there is 1 episodic-style kpcc program
	And the program has 2 episodes
	And each episode has 2 segments
	When I go to the program's page
	Then I should see the current episode's information
	And I should see the episode's primary asset
	And I should see a list of the current episode's segments
