Feature: Programs

Scenario: No Programs
	Given there are 0 kpcc programs
	And there are 0 other programs
	When I go to the programs page
	Then I should see that there is nothing to list with the message "There are currently no Local Programs"
	And I should see that there is nothing to list with the message "There are currently no Outside Programs"

