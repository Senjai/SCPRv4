Feature: Programs

Scenario: No Programs
	Given there are 0 kpcc programs
	And there are 0 other programs
	When I go to the programs page
	Then I should see that there is nothing to list with the message "There are currently no Local Programs"
	And I should see that there is nothing to list with the message "There are currently no Outside Programs"

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
		
Scenario: View a Program's page
	Given there are 2 kpcc programs
	When I go to a program's page
	Then I should see the program's information