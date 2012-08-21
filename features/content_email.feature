Feature: Content Email

Background:
	Given a blog entry
	
Scenario: Attempt to send an invalid message
	When I go to the content email page
	And I fill in the "new content email" form with invalid data
	And I submit the "new content email" form
	Then I should see the "new content email" form
	And I should see an error message

Scenario: Send a valid message
	When I go to the content email page
	And I fill in the "new content email" form with valid data
	And I submit the "new content email" form
	Then I should see the success page
	And the e-mail should have been sent